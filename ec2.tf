hi hello vanakkan da mapla ....
ulla file edhum irukadhu ....
en na idhu dummy file ...
prod branch la testig kaaga upload pannathu ...
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


#nothing hiiiiiii
