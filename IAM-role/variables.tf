### Variables creation

variable "project_id" {
    type = string
    default = "keerthi-reddy-manda-project"
}

variable "region" {
    type = string
    default = "us-central1"
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
    
