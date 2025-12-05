# Security group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg-${var.environment}"
  description = "Security group for RDS database"

  ingress {
    from_port   = var.rds_engine == "postgres" ? 5432 : 3306
    to_port     = var.rds_engine == "postgres" ? 5432 : 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow database connections"
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

  lifecycle {
    ignore_changes = [tags_all]
  }
}

# RDS Subnet Group for multi-AZ (optional but recommended)
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-${var.environment}"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Get default VPC subnets
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# RDS Database Instance (Free Tier Compatible)
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db-${var.environment}"
  engine         = var.rds_engine
  engine_version = var.rds_engine == "postgres" ? "13.23" : "8.0.35" # Free tier versions
  instance_class = var.rds_instance_class

  allocated_storage = var.rds_allocated_storage
  storage_type      = "gp2" # General Purpose SSD - free tier eligible
  iops              = null  # Don't set IOPS for gp2

  db_name  = var.rds_database_name
  username = var.rds_username
  password = var.rds_password

  # Free tier settings
  multi_az                        = false
  publicly_accessible             = true # Allow public access for lambda
  skip_final_snapshot             = true # Don't create final snapshot on destroy
  copy_tags_to_snapshot           = false
  storage_encrypted               = false # Free tier doesn't include encryption
  enabled_cloudwatch_logs_exports = []

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Backup settings (free tier: 7 days)
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.project_name}-db"
    Environment = var.environment
  }

  depends_on = [aws_security_group.rds]
}
