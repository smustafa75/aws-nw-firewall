

resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Access instances in public subnet"
  vpc_id      = aws_vpc.fw_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [  "0.0.0.0/0"]
  }
    ingress {
    description      = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    cidr_blocks = ["0.0.0.0/0"]
  }  
      ingress {
    description      = ""
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
