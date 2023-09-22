resource "null_resource" "execute_permission" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
      chmod +x src/extension/${var.extension_name}
      chmod +x src/${var.extension_name}/index.js
    EOT
  }
}

data "archive_file" "extension_file" {
  output_path = "${path.cwd}/${var.file_name}"
  source_dir  = "${path.cwd}/src"
  type        = "zip"

  depends_on = [null_resource.execute_permission]
}