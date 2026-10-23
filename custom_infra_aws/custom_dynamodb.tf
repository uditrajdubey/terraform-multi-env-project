resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "${var.custom_env}-my-dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Name        = "${var.custom_env}-dynamodb-table-1"
    Environment = var.custom_env
  }
}
