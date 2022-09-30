module "teleport-agent-terraform" {
  # source
  source = "./agent"

  region  = var.region
  profile = var.profile

  # Teleport Agent name is a unique agent name to identify the individual instance.
  teleport_agent_name = var.name

  # Teleport proxy hostname/port to connect the agent to - this must include a web UI port like :443 or :3080
  # Any security groups and networking for your agent must permit outbound traffic to flow to this host/port,
  # as well as to the configured reverse tunnel port for the cluster (defaults to 3024, but can also be multiplexed on 443/3080)
  # Don't include https:// in the URL. Any SSL/TLS certificates presented must use valid chains.
  teleport_proxy_hostname = var.proxy_url

  # Join token which will allow the agent to join the Teleport cluster.
  # This token must already be configured on your cluster and be valid for all Teleport services which the agent is providing access to.
  # i.e. to provide database, application and node/SSH access, the token should be created with
  # tctl tokens add --type=db,app,node
  # See the Teleport static/dynamic token documentation for more details.
  teleport_join_token = var.token

  ### Agent mode settings
  ### Note that all of these variables must have a value configured, even if you are not using that mode.
  ### A blank string ("") should be used to avoid setting them.
  ### Notes on labels:
  ### Labels cannot contain the pipe character '|' - this is used to delimit each key:value static label entry.
  ### Use a string like "env: dev|mode: agent" to add both "env: dev" and "mode: agent" static labels.
  ### Dynamic labels/commands cannot be configured using this module.

  # Database
  teleport_agent_db_enabled             = "false"
  teleport_agent_db_description         = ""
  teleport_agent_db_labels              = ""
  teleport_agent_db_name                = ""
  teleport_agent_db_redshift_cluster_id = ""
  teleport_agent_db_region              = ""
  teleport_agent_db_protocol            = ""
  teleport_agent_db_uri                 = ""
  # IAM role for Database agents
  # If set, this will automatically provision an instance IAM role which allows RDS database token generation.
  # This value can be found under "Resource ID" on the "Configuration" tab of the RDS console.
  # If not set, the instance profile will be blank and you will need to configure your own role/instance profile.
  teleport_agent_db_iam_resource_id = ""
  # If set, this will limit the allowed database users for token generation to the specified username string.
  # If not set, this will allow RDS token generation for all database users (*)
  teleport_agent_db_iam_db_username = ""

  # App
  teleport_agent_app_enabled              = "true"
  teleport_agent_app_description          = "${var.name} AWS Account"
  teleport_agent_app_labels               = "aws_account_id: ${data.aws_caller_identity.current.account_id}|project: ${var.name}"
  teleport_agent_app_insecure_skip_verify = ""
  teleport_agent_app_name                 = lower(var.name)
  teleport_agent_app_public_addr          = ""
  teleport_agent_app_uri                  = "https://console.aws.amazon.com"

  # SSH
  teleport_agent_ssh_enabled = "true"
  teleport_agent_ssh_labels  = "env: dev|mode: agent| project: ${var.name}"

  ### Settings for agent deployment
  # List of subnets to spawn agent instances in
  # Note that Teleport application access does not yet de-duplicate available applications, so
  # will show multiple copies of the same application for access if multiple replicas are used.
  # e.g. ["subnet-abc123abc123", "subnet-abc456abc456"]
  # These subnet IDs must exist in the region specified in your provider.tf file
  subnet_ids = var.subnet_ids
  # subnet_ids = ["subnet-0410f0052e8acd5e2"]

  # Instance type used for agent autoscaling group
  agent_instance_type = "t3.nano"

  # SSH key name to provision instances with for emergency access
  # This must be a key that already exists in the AWS account
  key_name = aws_key_pair.teleport_key.key_name

  ### Other settings you probably don't need to change
  # AMI ID to use
  # Agents can use OSS AMIs if preferred - Enterprise AMIs are not required.
  # See https://github.com/gravitational/teleport/blob/master/examples/aws/terraform/AMIS.md
  ami_id = var.ami_id

  # AWS KMS alias used for encryption/decryption, defaults to alias used in SSM
  kms_alias_name = "alias/aws/ssm"

  # Account ID which owns the AMIs used to spin up instances
  # You should only need to set this if you're building your own AMIs.
  #ami_owner_account_id = "123456789012"
}
