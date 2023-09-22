resource "null_resource" "execute_permission" {
  triggers = {
    run_on_folder = sha1(join("", [for f in fileset("${path.cwd}/src", "*"): filesha1(f)]))
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