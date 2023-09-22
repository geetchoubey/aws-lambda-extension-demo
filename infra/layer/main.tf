resource "aws_lambda_layer_version" "my_lambda_layer" {
  layer_name          = var.layer_name
  filename            = "${path.cwd}/${var.file_name}"
  compatible_runtimes = ["nodejs16.x", "nodejs18.x"]
  source_code_hash    = var.filehash
}