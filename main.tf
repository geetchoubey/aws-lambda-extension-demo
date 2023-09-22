terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "personal"
}

locals {
  file_name      = "layer_file.zip"
  extension_name = "my-lambda-extension"
}

module "archive_module" {
  source         = "./infra/archive"
  extension_name = local.extension_name
  file_name      = local.file_name
}

module "layer" {
  source     = "./infra/layer"
  file_name  = local.file_name
  layer_name = "my-lambda-extension-layer"
  filehash   = module.archive_module.filehash
}

module "iam" {
  source = "./infra/iam"
}

module "function" {
  source            = "./infra/function"
  function_name     = "test_lambda_function_for_extension"
  iam_role_arn      = module.iam.iam_role_arn
  dispatch_post_uri = var.dispatch_post_uri
}

module "function_with_layer" {
  source            = "./infra/function"
  function_name     = "test_lambda_function_for_extension_w_layer"
  layer_arn_list    = [module.layer.layer_arn]
  iam_role_arn      = module.iam.iam_role_arn
  dispatch_post_uri = var.dispatch_post_uri
}