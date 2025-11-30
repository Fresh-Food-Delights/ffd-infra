# A dedicated Security Group for VPC Interface Endpoints (Secrets Manager, SSM, etc.)
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg-${var.environment}"
  description = "Security Group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  # Ingress Rule: Allow HTTPS (port 443) traffic *from* anywhere within the VPC CIDR
  # This allows resources in the VPC (e.g., EC2) to securely connect to the endpoints.
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Use the VPC's own CIDR block to restrict traffic to the VPC itself
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTPS (443) from inside VPC to Endpoints"
  }

  # Egress Rule: Allow all outbound traffic (typically required for interface endpoints)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "vpc-endpoint-sg-${var.environment}"
    Environment = var.environment
  }
}