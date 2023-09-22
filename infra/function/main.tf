data "archive_file" "lambda_inline_code" {
  type        = "zip"
  output_path = "${path.cwd}/.terraform/lambda_code.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
  return "Hello from Lambda";
};

    EOF
    filename = "index.js"
  }
}

resource "aws_lambda_function" "my_function_test_extension" {
  function_name    = var.function_name
  role             = var.iam_role_arn
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_inline_code.output_base64sha256
  handler          = "index.handler"
  filename         = data.archive_file.lambda_inline_code.output_path
  layers           = var.layer_arn_list
  environment {
    variables = {
      DISPATCH_POST_URI       = var.dispatch_post_uri
      DISPATCH_MIN_BATCH_SIZE = 10
    }
  }
}