resource "aws_security_group" "sg-alb" {
    name        = "Security Group ALB"
    description = "Allow all inbound traffic"
    vpc_id     = aws_vpc.vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.private_subnet_1_cidr_block]
    }

    egress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.private_subnet_2_cidr_block]
    }

    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "sg-alb"
    }

    depends_on = [
        aws_vpc.vpc
    ]
}

resource "aws_lb_target_group" "tg-app" {
    name     = "tg-app"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb" "lb-application" {
    name               = "appliction"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.allow-http.id]
    subnets            = [
        aws_subnet.public-subnet-1.id,
        aws_subnet.public-subnet-2.id
    ]

    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "Application Load Balancer"
    }
}

output "elb_public_ip" {
    value = aws_lb.lb-application.dns_name
}

resource "aws_alb_listener" "lb-application-listener" {  
    load_balancer_arn = aws_lb.lb-application.arn
    port              = "80"
    protocol          = "HTTP"
    
    default_action {    
        target_group_arn = aws_lb_target_group.tg-app.arn
        type             = "forward"  
    }
}