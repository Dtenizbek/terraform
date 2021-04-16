region                     = "eu-central-1"
instance_type              = "t2.small"
enable_detailed_monitoring = true
key_pair = "Canadakey"

allow_ports = ["80", "443"]

common_tags = {
  Owner       = "Dtenizbek"
  Project     = "Phoenix"
  CostCenter  = "123477"
  Environment = "prod"
}