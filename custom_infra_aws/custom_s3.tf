resource "aws_s3_bucket" "example" {
  bucket = "${var.custom_env}-udits-terra-project-bucket"

  tags = {
    Name        = "${var.custom_env}-udits-terra-project-bucket"
    Environment = var.custom_env
  }
}