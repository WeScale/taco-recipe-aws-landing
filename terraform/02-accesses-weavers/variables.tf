variable "account_id_list" {
  type = "map"
}

variable "deploy_env" {
  type = "string"
}

variable "deploy_region" {
  type = "string"
}

variable "memberlist_weavers_base" {
  type    = "list"
  default = []
}

variable "organization_role_name" {
  type = "string"
}

variable "tfstate_bucket_name" {
  type = "string"
}

variable "tfstate_kms_key_arn" {
  type = "string"
}

variable "tf_lock_dynamo_table" {
  type = "string"
}