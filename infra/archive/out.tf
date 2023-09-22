output "filehash" {
  value = data.archive_file.extension_file.output_base64sha256
}