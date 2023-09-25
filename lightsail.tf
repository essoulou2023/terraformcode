resource "aws_lightsail_instance" "example" {
  name              = "my-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_1_0"
  key_pair_name     = "my-key-pair"
  tags = {
    env = "dev"
  }
user_data = <<-EOF>> 
    inline =  [
      "sudo yum update -y",
      "sudo yum install unzip wget httpd -y",
      "sudo wget https://github.com/utrains/static-resume/archive/refs/heads/main.zip",
      "sudo unzip main.zip",
      "sudo rm -rf /var/www/html/*",
      "sudo cp -r static-resume-main/* /var/www/html/",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("<path_to_private_key>")
      host        = self.public_ip_address
    }
  }

output "instance_public_ip" {
  value = aws_lightsail_instance.example.public_ip_address
}