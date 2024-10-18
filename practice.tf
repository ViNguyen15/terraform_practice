	
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.5.2"
    }
  }
}

provider "linode" {
  token = var.access_token
}

# resource "linode_instance" "fluffy_server" {
#   count = 3  # This will create 3 instances

#   label  = "Fluffy-Server-${count.index + 1}"  # Use count.index to generate unique labels
#   image  = "linode/CentOS7"
#   type   = "g6-nanode-1"
#   region = "us-southeast"
# }

resource "linode_instance" "mochi_home" {
  count = 1  # This will create 3 instances

  label  = "Mochi_Home_${count.index + 1}"  # Use count.index to generate unique labels
  image  = "linode/CentOS7"
  type   = "g6-nanode-1"
  region = "us-southeast"

  connection {
    type        = "ssh"
    user        = "root"
    password    = "$Mochi Server 2"
    timeout     = "2m"
    host        = self.ipv4_address
    port        = 22
    
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo yum install -y gnome-terminal",
      "sudo usermod -aG docker $USER",
      "sudo yum install -y epel-release",
      "sudo yum install -y docker-compose",
    ]
  }
}


output "linode_ip" {
  value = linode_instance.mochi_home[0].ipv4
}