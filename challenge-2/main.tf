resource "docker_image" "php-httpd-image" {
    name = "php-httpd:challenge"

    build {
        path = "lamp_stack/php_httpd"
        label = {
          challenge = "second"
        }
    }
}

resource "docker_container" "php-httpd" {
    name = "webserver"
    image = docker_image.php-httpd-image.name
    
    hostname = "php-httpd"


    networks_advanced {
        name = docker_network.private_network.name
    }

    ports {
       ip = "0.0.0.0"
       internal = "80"
       external = "80"
    }

    volumes {
      container_path = "/var/www/html"
      host_path = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    }

    labels {
      label = "challenge"
      value = "second"
    }
}

resource "docker_container" "phpmyadmin" {
    depends_on = [ docker_container.mariadb ]
    name = "db_dashboard"
    image = "phpmyadmin/phpmyadmin"

    hostname = "phpmyadmin"

    networks_advanced {
        name = docker_network.private_network.name
    }

    ports {
        internal = 80
        external = 8081
        ip = "0.0.0.0"
    }

    labels {
      label = "challenge"
      value = "second"
    }

    links = ["db:mysql"]  # it was asked to do this on the challenge, but is deprecated, docker now has a built-in networking system (as bridge, the one we are using)
}


resource "docker_image" "mariadb-image" {
  name = "mariadb:challenge"

  build {
    path = "lamp_stack/custom_db"
    label = {
        challenge = "second"
    }
  }
}

resource "docker_volume" "mariadb_volume" {
    name = "mariadb-volume"
}

resource "docker_container" "mariadb" {
    name = "db"
    image = docker_image.mariadb-image.name

    hostname = "db"

    networks_advanced {
        name = docker_network.private_network.name
    }

    ports {
        external = 3306
        internal = 3306
        ip = "0.0.0.0"
    }

    volumes {
        volume_name = docker_volume.mariadb_volume.name
        container_path = "/var/lib/mysql"
    }

    labels {
      label = "challenge"
      value = "second"
    }

    env = [ 
        "MYSQL_ROOT_PASSWORD=1234",
        "MYSQL_DATABASE=simple-website"
     ]
}
