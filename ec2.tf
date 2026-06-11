resource "aws_instance" "pub_server" {
  ami                     = "ami-0aa31b568c1e8d622"
  instance_type           = "t3.micro"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id                = aws_subnet.public_subnet.id
  key_name  = "hyd_pem" 

  tags = { 

    Name = "pub_server" 
  }

}




for dev branch for all of us information

