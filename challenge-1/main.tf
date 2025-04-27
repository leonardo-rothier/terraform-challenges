locals {
  app_labels = { name = "webapp"}
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"   # the actual Deployment name (you can see this using: kubectl get deployments)
    labels = {
      name = "frontend"
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
          name = "simple-webapp"
          image = "kodekloud/webapp-color:v1"

          port {
            container_port = 8080
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
            port = 8080         # Service port
            target_port = 8080  # Container port (matches the Deployment)
            node_port = 30080   # External access port
        }
    }
}