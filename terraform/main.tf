# key pair (login)

resource aws_key_pair my_key {
        key_name = "case-study-2-key"
        public_key = file("case-study-2-key.pub")
}

# VPC & security group

resource aws_default_vpc default{

        # this is default VPC - usually used when  ec2 launch
}

resource aws_security_group my_security_group{
        name = "automate-sg"
        description = "this will add a TF generated security grp"
        vpc_id = aws_default_vpc.default.id

        #inbound rules - ingress
        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "SSH open"
        }
        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "HTTP open"
        }
        ingress {
                from_port = 3000
                to_port = 3000
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "HTTP open"
        }

        #outbound rules - egress
        egress{
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                description = "all outbound  open"
        }

        # putting tags is optional same as on  - console
        tags = {
                Name = "automate-security-grp"
        }

}

# ec2 instance

resource "aws_instance" "my_instance"{
	key_name = aws_key_pair.my_key.key_name
	security_groups = [aws_security_group.my_security_group.name]
	instance_type = "t2.micro"
	ami = "ami-020cba7c55df1f615" # amazon machine id for ubuntu
	
	root_block_device{
		volume_size = 15
		volume_type = "gp3"

	}

	tags = {
		Name = "Case-study-instance"
	}


}





