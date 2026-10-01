variable "harness_account_id" {
  type        = string
  description = "Harness account identifier."
}

variable "harness_platform_api_key" {
  type        = string
  sensitive   = true
  description = "NextGen platform API key. Create in Harness (Profile → API Keys) or set HARNESS_PLATFORM_API_KEY."
}

variable "harness_org_id" {
  type        = string
  description = "Organization identifier where the project lives. The pre-created default org is usually \"default\" (confirm under Account Settings → Organizations)."
  default     = "default"
}

variable "harness_project_id" {
  type        = string
  description = "Project identifier to manage RBAC for."
}

variable "create_project" {
  type        = bool
  description = "If true, create the project via Terraform. If false, assign RBAC to an existing project."
  default     = false
}

variable "rbac_principal_identifier" {
  type        = string
  description = "Principal to grant access (user id, user group id, service account id, etc.)."
}
