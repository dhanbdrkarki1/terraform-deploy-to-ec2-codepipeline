# Fetch the default VPC in us-east-2
data "aws_vpc" "default" {
  default = true
}

# Fetch the default subnets in us-east-2
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "http" "my_public_ip" {
  url = "https://ipinfo.io/ip"
  request_headers = {
    Accept = "text/plain"
  }
}
