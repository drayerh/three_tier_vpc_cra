# Creating 1st EC2 instance in Public Subnet
resource "aws_instance" "demoinstance1" {
  ami                         = "ami-087c17d1fe0178315"             
  instance_type               = "t2.micro"
  id                          = "var.aws_instance.demoinstance1.id"  
  count                       = 1
  key_name                    = "my-ec2key-cr"
  vpc_security_group_ids      = ["${aws_security_group.demosg.id}"]
  subnet_id                   = aws_subnet.demoinstance1.subnet_id
  associate_public_ip_address = true
  user_data                   = file("data.sh")

  tags = {
    Name = "My Public Instance"
  }
}

# Creating 2nd EC2 instance in Public Subnet
resource "aws_instance" "demoinstance2" {
  ami                         = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  id                          = "var.aws_instance.demoinstance2.id"  
  count                       = 1
  key_name                    = "my-ec2key-cr"
  vpc_security_group_ids      = ["${aws_security_group.demosg.id}"]
  subnet_id                   = aws_subnet.demoinstance2.subnet_id
  associate_public_ip_address = true
  user_data                   = file("data.sh")

  tags = {
    Name = "My Public Instance 2"
  }
}

