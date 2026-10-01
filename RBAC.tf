
# RBAC assignments for Harness NextGen.
# Users must exist in the project before project-scoped role assignments succeed.

locals {
  rbac_users = jsondecode(data.http.rbac_users_from_github.body)
}

data "http" "rbac_users_from_github" {
  url = "https://raw.githubusercontent.com/lloyds-demo/user-oids/main/1.json"
}

resource "harness_platform_user" "project" {
  for_each = local.rbac_users

  org_id      = var.harness_org_id
  project_id  = var.harness_project_id
  email       = each.value
  user_groups = ["_project_all_users"]
}

moved {
  from = harness_platform_user.test_project_member
  to   = harness_platform_user.project["tyler_pipeline_editor"]
}

resource "harness_platform_role_assignments" "tyler_pipeline_editor" {
  org_id                    = var.harness_org_id
  project_id                = var.harness_project_id
  resource_group_identifier = "_all_project_level_resources"
  # Built-in project roles: _pipeline_executor, _project_viewer, _project_admin (no _pipeline_editor).
  role_identifier           = "_pipeline_executor"

  principal {
    identifier = harness_platform_user.project["tyler_pipeline_editor"].identifier
    type       = "USER"
  }

  depends_on = [harness_platform_user.project]
}

resource "harness_platform_role_assignments" "tyler_denied_pipeline_viewer" {
  org_id                    = var.harness_org_id
  project_id                = var.harness_project_id
  resource_group_identifier = "_all_project_level_resources"
  role_identifier           = "_project_viewer"
  disabled                  = true

  principal {
    identifier = harness_platform_user.project["tyler_denied_pipeline_viewer"].identifier
    type       = "USER"
  }

  depends_on = [harness_platform_user.project]
}
