variable "project_id" {
    type = string
}

variable "region" {
    type = string
}

variable "zone" {
    type = string

}

variable "user_email" {
    description = "User enail to assign the role"
    type = string
}

variable "users" {
    description = "assign role to multiple users"
    type = list(string)
}

variable "role_id"{
    description = "role to assign"
    type = string
}

variable "vpcs"{
    description = "VPCs and their single subnet configuration"
    type = map(object({
        subnet_name = string
        cidr_range = string
    }))
}

