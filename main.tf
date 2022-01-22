provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "single_instance" {
  name    = var.name_instance
  vpc_id  = var.vpc_id

  ingress {
    description = "SSH Franz"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_access_ip
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_access_cidr
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master_instance" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = var.subnet_id_a
  instance_type               = "m5a.large"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.single_instance.id] //To do
  key_name                    = var.key_name

  tags = {
    Name = "Kube Master"
  }

  root_block_device {
    volume_size             = 30
    delete_on_termination   = true
    encrypted               = true
  }

  provisioner "file" {
    source      = "k8scp.sh"
    destination = "/home/ubuntu/k8scp.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.master_instance.public_ip
    }
  }
  
  provisioner "file" {
    source      = "kubeadm.yaml"
    destination = "/home/ubuntu/kubeadm.yaml"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.master_instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'",
      "chmod +x /home/ubuntu/k8scp.sh",
      "bash /home/ubuntu/k8scp.sh | tee $HOME/cp.out"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.master_instance.public_ip
    }
  }
}

resource "aws_instance" "worker_one_instance" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = var.subnet_id_b
  instance_type               = "m5a.large"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.single_instance.id] //To do
  key_name                    = var.key_name

  tags = {
    Name = "Kube Worker 1"
  }

  root_block_device {
    volume_size             = 30
    delete_on_termination   = true
    encrypted               = true
  }

  provisioner "file" {
    source      = "k8sSecond.sh"
    destination = "/home/ubuntu/k8sSecond.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.worker_one_instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'",
      "chmod +x /home/ubuntu/k8sSecond.sh",
      "bash /home/ubuntu/k8sSecond.sh | tee $HOME/cp.out"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.worker_one_instance.public_ip
    }
  }   
}

resource "aws_instance" "worker_two_instance" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = var.subnet_id_c
  instance_type               = "m5a.large"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.single_instance.id] //To do
  key_name                    = var.key_name

  tags = {
    Name = "Kube Worker 2"
  }

  root_block_device {
    volume_size             = 30
    delete_on_termination   = true
    encrypted               = true
  }   

  provisioner "file" {
    source      = "k8sSecond.sh"
    destination = "/home/ubuntu/k8sSecond.sh"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.worker_two_instance.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'",
      "chmod +x /home/ubuntu/k8sSecond.sh",
      "bash /home/ubuntu/k8sSecond.sh | tee $HOME/cp.out"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.worker_two_instance.public_ip
    }
  }   
}