egion                     = "ca-central-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = false

allow_ports = ["80", "22", "8080"]

common_tags = {
  Owner       = "Dtenizbek"
  Project     = "Phoenix"
  CostCenter  = "12345"
  Environment = "dev"
}

