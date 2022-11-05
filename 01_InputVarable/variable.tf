variable "InstanceType" {
}

variable "environment_name" {

}

variable "region" {

  type        = string
  description = "Region detials"
  default     = "us-east-1"

}

variable "instanceCount" {

  type        = number
  default     = 1
  description = "No of Instance required"

}

variable "EnablepublicIp" {

  description = "Enabled Public IP Address"
  type        = bool
  default     = true

}

variable "user_names" {
  description = "IAM username"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}

variable "project_Enviroment" {

  description = "Project name and env"
  type        = map(string)
  default = {
    "Project"    = "ProjectX",
    "Enviroment" = "dev"
  }


}