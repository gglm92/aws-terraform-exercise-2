resource "aws_launch_template" "web-servers" {
    name = "web-servers"

    image_id = var.instance_ami
    instance_type = var.instance_type
    key_name = var.key_name

    vpc_security_group_ids = [aws_security_group.allow-http.id]

    user_data = filebase64("script.tpl")
}

resource "aws_autoscaling_group" "web-autoscaling" {
  name = "web-servers-asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 4

  health_check_type    = "ELB"
  target_group_arns= [
    aws_lb_target_group.tg-app.arn
  ]

  launch_template {
    id      = aws_launch_template.web-servers.id
    version = "$Latest"
  }
  #availability_zones = [var.availability_zone_1, var.availability_zone_2]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity="1Minute"

  vpc_zone_identifier  = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name
}