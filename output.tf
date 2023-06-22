output "ALB_DNS" {
  value = aws_lb.terraformALB.dns_name
}