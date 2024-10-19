variable "access_token"{
    description = "access api token for linode"
    type = string
    sensitive = true
}

variable "root_password"{
    description = "password to host"
    type = string
    sensitive = true
}