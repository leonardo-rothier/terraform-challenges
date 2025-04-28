locals {
  app_labels = { name = "webapp"}
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = var.deployment_name  # the actual Deployment name (you can see this using: kubectl get deployments)
    labels = {
      name = var.deployment_name
    }
  }

  spec { # Deployment configuration (define the desired state of the deployment)
    replicas = 4 # numbers of identical pod instances to maintain

    selector {  # This will tell the Deployment how to find which Pods it manages (must match the pod template's)
      match_labels = local.app_labels
    }

    template { # Pod specification
      metadata {
        labels = local.app_labels   # must match the selector.match_labels
      }
      spec {  # Defines what containers run in each Pod
        container {
          name = var.container_name
          image = var.image_name

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "webapp-service" {
    depends_on = [kubernetes_deployment.frontend]
    metadata {
      name = "webapp-service"
    }

    spec {
        type = "NodePort"

        selector = local.app_labels  #this must match the pod labels from the deployment

        port {
            port = var.service_port         # Service port (cluster-internal)
            target_port = var.container_port  # Fowards to the pod's cotainer_port
            node_port = var.external_port   # External access port
        }
    }
}