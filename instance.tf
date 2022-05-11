provider "aws" {
   region     = "us-east-1"
   access_key = ""
   secret_key = ""
   
}

resource "aws_network_interface" "eth0" {
     subnet_id       = var.subnet_id
     security_groups = ["${var.security_group_ids}"]
     tags = var.security_tags 
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.latest-image.id

  instance_type = var.instance_type
  key_name      = var.key_pair

  network_interface {
     network_interface_id       = aws_network_interface.eth0.id
     device_index               = 0
    } 

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_alias.DiskEncryptionKey.target_key_arn
  }

  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = file(var.private_key_file)
    host     = self.private_ip
  }

#provisioner "remote-exec" {
#    inline = var.post_install_commands
#}

  tags        = var.security_tags
  volume_tags = var.security_tags

}