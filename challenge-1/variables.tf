variable "deployment_name" {
    description = "Kubernetes Deployment name"
    type = string
}

variable "container_name" {
    description = "The container running inside the kubernetes pod name"
    type = string
}

variable "image_name" {
    description = "Container's image"
    type = string
}

variable "container_port" {
    description = "Defines the port for the application inside the container listens on"
    type = number
}

variable "service_port" {
    description = "Defines the port the kubernetes service listens on"
    type = number
}

variable "external_port" {
    description = "The port that are going to be expose externally"
    type = number
}