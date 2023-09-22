variable "file_name" {
  description = "Filename will be substituted with \"path/<filename.zip>\""
  type        = string
  validation {
    condition     = can(regex(".*\\.zip$", var.file_name))
    error_message = "File name must end in \".zip\""
  }
}

variable "extension_name" {
  type = string
}