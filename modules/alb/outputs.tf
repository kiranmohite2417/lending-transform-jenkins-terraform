output "alb_arn" {
  description = "The ARN of the ALB."
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.alb.dns_name
}

output "frontend_target_group_arn" {
  description = "The ARN of the frontend target group."
  value       = aws_lb_target_group.frontend_tg.arn
}

