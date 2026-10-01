# Project-level RBAC in Harness NextGen (Platform)

terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = "0.45.8"
    }
  }
}

provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = var.harness_account_id
  platform_api_key = var.harness_platform_api_key
}

resource "harness_platform_project" "this" {
  count = var.create_project ? 1 : 0

  identifier  = var.harness_project_id
#   name        = coalesce(var.harness_project_name, var.harness_project_id)
name        = var.harness_project_id
  org_id      = var.harness_org_id
  description = "Managed by Terraform"
}

resource "harness_platform_pipeline" "demo" {
  org_id     = var.harness_org_id
  project_id = var.harness_project_id

  identifier = "demo_pipeline"
  name       = "Demo Pipeline"
  description = "A demo pipeline managed by Terraform."
  yaml = <<-EOT
    pipeline:
      name: Demo Pipeline
      identifier: demo_pipeline
      projectIdentifier: ${var.harness_project_id}
      orgIdentifier: ${var.harness_org_id}
      tags: {}
      stages:
        - stage:
            name: Demo Stage
            identifier: Demo_Stage
            description: ""
            type: Custom
            spec:
              execution:
                steps:
                  - step:
                      type: ShellScript
                      name: Say Hello
                      identifier: Say_Hello
                      spec:
                        shell: Bash
                        onDelegate: true
                        source:
                          type: Inline
                          spec:
                            script: |-
                              echo "Hello World!"
                              echo "Running from Harness"
                        environmentVariables: []
                        outputVariables: []
                      timeout: 10m
            tags: {}
  EOT
}





# locals {
#   project_id = var.create_project ? harness_platform_project.this[0].identifier : var.harness_project_id
# }

# resource "harness_platform_role_assignments" "project_rbac" {
#   org_id                    = var.harness_org_id
#   project_id                = local.project_id
#   resource_group_identifier = var.rbac_resource_group_identifier
#   role_identifier           = var.rbac_role_identifier
#   disabled                  = false
#   managed                   = false

#   principal {
#     identifier = var.rbac_principal_identifier
#     type       = var.rbac_principal_type
#   }
# }
