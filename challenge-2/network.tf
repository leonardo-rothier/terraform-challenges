resource "docker_network" "private_network" {
    name = "my_network"
    driver = "bridge"

    attachable = true 

    labels {
      label = "challenge"
      value = "second"
    }
}