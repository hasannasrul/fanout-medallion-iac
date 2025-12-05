# RDS Security Group - Optional, only needed if Lambda is deployed in VPC
# For free tier setup, RDS is publicly accessible so this is not required
resource "aws_security_group" "rds_sg" {
  count = var.vpc_id != "" ? 1 : 0

  name        = "${var.project_name}-rds-sg-${var.environment}"
  description = "Security group for RDS database (optional for VPC Lambda)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow PostgreSQL from anywhere"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow MySQL from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}
