# -----------------------------------------------------------------------------
# Group that allow users to assume roles named like "${group_name}-*" in
# specified accounts
# -----------------------------------------------------------------------------
module "watchers_base_group" {
  source = "../mod_group_allowing_assume_role"

  group_name = "watchers"

  allow_assume_prefixed_roles_in_accounts = [
    "${values(var.account_id_list)}",
  ]

  members = "${var.memberlist_watchers_base}"
}

# -----------------------------------------------------------------------------
# Role assumable by users, linked to root account
# -----------------------------------------------------------------------------
module "root_watchers_base_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["root"]}"

  template    = "${file("${path.module}/policies/watchers_base.json")}"
  allow_users = "${var.memberlist_watchers_base}"
  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  allow_assume_prefixed_roles_in_accounts = [
    "${var.account_id_list["sec"]}",
    "${var.account_id_list["dev"]}",
    "${var.account_id_list["rec"]}",
    "${var.account_id_list["pil"]}",
    "${var.account_id_list["prd"]}",
  ]
}

# -----------------------------------------------------------------------------
# Role assumable by specified role, linked to target account
# root_account_id is used to mix with allow_roles names to generate assumed role
# ARNs.
# -----------------------------------------------------------------------------
provider "aws" {
  alias = "sec"

  assume_role {
    session_name = "keepers-base"
    role_arn = "arn:aws:iam::${var.account_id_list["sec"]}:role/keepers-base"
  }
}
module "root_watchers_sec_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["sec"]}"

  template    = "${file("${path.module}/policies/watchers_sub.json")}"
  allow_users = "${var.memberlist_watchers_base}"

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  providers {
    aws.module_local = "aws.sec"
  }
}

provider "aws" {
  alias = "dev"

  assume_role {
    session_name = "keepers-base"
    role_arn     = "arn:aws:iam::${var.account_id_list["dev"]}:role/keepers-base"
  }
}
module "root_watchers_dev_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["dev"]}"

  template    = "${file("${path.module}/policies/watchers_sub.json")}"
  allow_users = "${var.memberlist_watchers_base}"

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  providers {
    aws.module_local = "aws.dev"
  }
}

provider "aws" {
  alias = "rec"

  assume_role {
    session_name = "keepers-base"
    role_arn     = "arn:aws:iam::${var.account_id_list["rec"]}:role/keepers-base"
  }
}
module "root_watchers_rec_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["rec"]}"

  template    = "${file("${path.module}/policies/watchers_sub.json")}"
  allow_users = "${var.memberlist_watchers_base}"

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  providers {
    aws.module_local = "aws.rec"
  }
}

provider "aws" {
  alias = "pil"

  assume_role {
    session_name = "keepers-base"
    role_arn     = "arn:aws:iam::${var.account_id_list["pil"]}:role/keepers-base"
  }
}
module "root_watchers_pil_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["pil"]}"

  template    = "${file("${path.module}/policies/watchers_sub.json")}"
  allow_users = "${var.memberlist_watchers_base}"

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  providers {
    aws.module_local = "aws.pil"
  }
}

provider "aws" {
  alias = "prd"

  assume_role {
    session_name = "keepers-base"
    role_arn     = "arn:aws:iam::${var.account_id_list["prd"]}:role/keepers-base"
  }
}
module "root_watchers_prod_role" {
  source = "../mod_role_for_users"

  group_name = "watchers"
  role_name  = "base"

  root_account_id   = "${var.account_id_list["root"]}"
  target_account_id = "${var.account_id_list["prd"]}"

  template    = "${file("${path.module}/policies/watchers_sub.json")}"
  allow_users = "${var.memberlist_watchers_base}"

  tf_lock_dynamo_table = "${var.tf_lock_dynamo_table}"
  tfstate_bucket_name = "${var.tfstate_bucket_name}"

  providers {
    aws.module_local = "aws.prd"
  }
}
