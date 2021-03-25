provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "prod" {
  identifier           = "prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = data.aws_secretsmanager_secret_version.rds_password.secret_string
}
//Generate password
resource "random_password" "main" {
  length           = 20
  special          = true
  override_special = "#!()_"
}


resource "aws_secretsmanager_secret" "rds_password" {
  name                    = "/prod/rds/password"
  description             = "Password for my RDS Database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.main.result
}
//Store all RDS parameters
resource "aws_secretsmanager_secret" "rds" {
  name                    = "/prod/rds/all"
  description             = "All Details my RDS Database"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    rds_address  = aws_db_instance.prod.address
    rds_password = random_password.main.result
    rds_port     = aws_db_instance.prod.port
    rds_username = aws_db_instance.prod.username
  })
}
//retrieve password
data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id  = aws_secretsmanager_secret.rds_password.id
  depends_on = [aws_secretsmanager_secret_version.rds_password]
}
// Retrieve all 
data "aws_secretsmanager_secret_version" "rds" {
  secret_id  = aws_secretsmanager_secret.rds.id
  depends_on = [aws_secretsmanager_secret_version.rds]
}
// Store Password
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/prod-mysql-rds/password"
  description = "Master Password for RDS Database"
  type        = "SecureString"
  value       = random_password.main.result
}
// Retrive Password
data "aws_ssm_parameter" "rds_password" {
  name       = "/prod/prod-mysql-rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}


output "rds_address" {
  value = aws_db_instance.prod.address
}

output "rds_port" {
  value = aws_db_instance.prod.port
}

output "rds_username" {
  value = aws_db_instance.prod.username
}
output "rds_password" {
  value = data.aws_ssm_parameter.rds_password.value
}
output "rds_all" {
  value = jsonencode(data.aws_secretsmanager_secret_version.rds.secret_string)
  
}