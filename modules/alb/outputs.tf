output "alb_arn" { value = aws_lb.alb.arn }
output "alb_dns_name" { value = aws_lb.alb.dns_name }
output "frontend_target_group_arn" { value = aws_lb_target_group.frontend_tg.arn }
