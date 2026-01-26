variable "project_id" {type = string}

variable "region" {type = string}

variable "zone" {type = string}

variable "vpc_name" {type = string}

variable "subnet_name" {type = string}

variable "cidr_range" {type = string}

variable "vm_name" {type = string}
variable "machine_type" {type = string}
variable "image" {type = string}

variable "tags" {
    type = list(string)
}
