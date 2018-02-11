resource "digitalocean_loadbalancer" "platzi-devops-05" {
  name = "platzi-devops-lb"
  region = "sfo2"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 3000
    target_protocol = "http"
  }

  healthcheck {
    port = 3000
    protocol = "http"
    path = "/"
  }

  droplet_tag = "${digitalocean_tag.platzi-devops-05.name}"
}

resource "digitalocean_tag" "platzi-devops-05" {
  name = "platzi-devops"
}

resource "digitalocean_droplet" "platzi-devops-05" {
  count  = 1
  image  = "31640252"
  name   = "platzi-devops-05"
  region = "sfo2"
  size   = "s-1vcpu-1gb"
  ssh_keys = [18198313]
  tags = ["${digitalocean_tag.platzi-devops-05.id}"]
  user_data = <<EOF
#cloud-config
coreos:
  units:
    - name: "docker-nodeapp.service"
      command: "start"
      content: |
        [Unit]
        Description=platzi docker container
        After=docker.service

        [Service]
        ExecStart=/usr/bin/docker run -d -p 3000:3000 nodeapp 
EOF
}