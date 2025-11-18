# modules/ec2/main.tf

resource "aws_iam_role" "ssm" {
  count = var.enable ? 1 : 0
  name  = "ffd-${var.environment}-${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enable ? 1 : 0
  role       = aws_iam_role.ssm[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  count = var.enable ? 1 : 0
  name  = "ffd-${var.environment}-${var.name}-ssm-profile"
  role  = aws_iam_role.ssm[0].name
}

resource "aws_instance" "this" {
  count = var.enable ? 1 : 0

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ssm[0].name

  tags = merge(
    {
      Name        = "ffd-${var.environment}-${var.name}"
      Environment = var.environment
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
