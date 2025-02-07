# Define AMI IDs for different Windows Server versions
variable "ami_2016" {
  description = "AMI ID for Windows Server 2016"
  default     = "ami-034492fa151bbd598"
}

variable "ami_2022" {
  description = "AMI ID for Windows Server 2022"
  default     = "ami-03d1e139780958698"
}
