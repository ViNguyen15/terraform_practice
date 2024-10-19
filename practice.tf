	
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
  image  = "linode/centos-stream9"
  type   = "g6-nanode-1"
  region = "us-southeast"
  root_pass = var.root_password

  provisioner "remote-exec" {


    connection {
      type        = "ssh"
      user        = "root"
      password    = var.root_password
      timeout     = "5m"
      host        = self.ip_address
      port        = 22
      
    }

  
    inline = [
      "sudo yum clean all",
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo yum install -y gnome-terminal",
      "sudo usermod -aG docker root",
      "sudo yum install -y epel-release",
      "sudo yum install -y docker-compose",
      "docker pull vinguyen15/weightlifter-api:version1.0",
      "docker run -d -p 8080:8080 vinguyen15/weightlifter-api:version1.0",
      "echo 'Setup complete'",
    ]
  }
}

resource "time_sleep" "wait_for_instance" {
  depends_on = [linode_instance.mochi_home]
  create_duration = "60s"  # Wait for 60 seconds
}


output "linode_ip" {
  value = linode_instance.mochi_home[0].ipv4
}

