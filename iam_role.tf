
## Custom IAM role creation 

```
resource "google_project_iam_custom_role" "custom_role" {
    project = var.project_id
    role_id = "created"
    title = "created role"
    description = "custom role creation for practise"
    stage = "GA"

    permissions = [
        "compute.instances.create",
        "compute.acceleratorTypes.list",
        "compute.disks.create",
        "compute.disks.list",
        "compute.instances.list",
        "compute.instances.setServiceAccount",
        "compute.machineTypes.list",
        "compute.networks.get",
        "compute.networks.list",
        "compute.projects.get",
        "compute.regions.list",
        "compute.subnetworks.get",
        "compute.subnetworks.list",
        "compute.subnetworks.use",
        "compute.subnetworks.useExternalIp",
        "compute.zones.list"
    ]
}
```
## IAM role binding to single user 

```
resource "google_project_iam_member" "assign_custom_role_to_user" {
  project = var.project_id
  role = "projects/${var.project_id}/roles/${var.role_id}"
  member  = "user:${var.user_email}"

  depends_on = [google_project_iam_custom_role.custom_role]
}
```

## IAM role binding to multi user

```
resource "google_project_iam_member" "multi_user_binding" {
  for_each = toset(var.users)

  project = var.project_id
  role    = "projects/${var.project_id}/roles/${var.role_id}"
  member  = "user:${each.value}"

  depends_on = [google_project_iam_custom_role.custom_role]
}
```


