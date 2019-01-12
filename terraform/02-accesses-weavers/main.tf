# -----------------------------------------------------------------------------
# Group that allow users to assume roles named like "${group_name}-*" in
# specified accounts
# -----------------------------------------------------------------------------
module "weavers_base_group" {
  source = "../mod_group_allowing_assume_role"

  group_name = "weavers"

  allow_assume_prefixed_roles_in_accounts = [
    "${var.account_id_list["root"]}",
  ]

  members = "${var.memberlist_weavers_base}"
}

# -----------------------------------------------------------------------------
# Role assumable by users, linked to root account
# -----------------------------------------------------------------------------
module "root_weavers_base_role" {
  source = "../mod_role_for_users"

  group_name = "weavers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["root"]}"

  template    = "${file("${path.module}/policies/weavers_base.json")}"
  allow_users = "${var.memberlist_weavers_base}"

  allow_assume_prefixed_roles_in_accounts = [
    "${var.account_id_list["pil"]}",
    "${var.account_id_list["prd"]}",
  ]

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"

  tfstate_bucket_name = "${var.tfstate_bucket_name}"
  tfstate_kms_key_arn = "${var.tfstate_kms_key_arn}"
}

# -----------------------------------------------------------------------------
# Role assumable by specified role, linked to target account
# root_account_id is used to mix with allow_roles names to generate assumed role
# ARNs.
# -----------------------------------------------------------------------------

provider "aws" {
  alias = "pil"

  assume_role {
    session_name = "keepers-base"
    role_arn = "arn:aws:iam::${var.account_id_list["pil"]}:role/keepers-base"
  }
}
module "pil_weavers_base_role" {
  source = "../mod_role_for_roles"

  group_name = "weavers"
  role_name  = "base"

  root_account_id = "${var.account_id_list["root"]}"

  template = "${file("${path.module}/policies/weavers_sub.json")}"

  allow_roles = [
    "${module.root_weavers_base_role.role_name}",
  ]

  target_account_id = "${var.account_id_list["pil"]}"

  organization_role_name = "${var.organization_role_name}"

  providers {
    aws = "aws.pil"
  }
}

provider "aws" {
  alias = "prd"

  assume_role {
    session_name = "keepers-base"
    role_arn = "arn:aws:iam::${var.account_id_list["prd"]}:role/keepers-base"
  }
}
module "prd_weavers_base_role" {
  source = "../mod_role_for_roles"

  group_name = "weavers"
  role_name  = "base"

  root_account_id = "${var.account_id_list["root"]}"

  template = "${file("${path.module}/policies/weavers_sub.json")}"

  allow_roles = [
    "${module.root_weavers_base_role.role_name}",
  ]

  target_account_id = "${var.account_id_list["prd"]}"

  organization_role_name = "${var.organization_role_name}"

  providers {
    aws = "aws.prd"
  }
}
