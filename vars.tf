// Region is AWS region, the region should support EFS
variable "region" {
  type = string
}

variable "profile" {
  type        = string
  description = "AWS profile to use"
}

variable "name" {
  type        = string
  description = "Account Name"
}

variable "proxy_url" {
  type        = string
  description = "Account Name"
}

variable "token" {
  type        = string
  sensitive   = true
  description = "Teleport token"
}

# List of subnets to spawn agent instances in
# Note that Teleport application access does not yet de-duplicate available applications, so
# will show multiple copies of the same application for access if multiple replicas are used.
# e.g. ["subnet-abc123abc123", "subnet-abc456abc456"]
# These subnet IDs must exist in the region specified in your provider.tf file
variable "subnet_ids" {
  type = set(string)
}

variable "ami_id" {
  type = string
  default = "ami-09a09195c58040c6f"
  description = "ID of Teleport AMI - eu-west-2 AMI by default. Replace if using a different region (https://github.com/gravitational/teleport/blob/master/examples/aws/terraform/AMIS.md)"
}
