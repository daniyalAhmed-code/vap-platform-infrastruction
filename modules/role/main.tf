resource "aws_iam_role" "lambda_catalog_updater_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_catalog_updater"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role" "lambda_backend_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_backend"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_asset_uploader_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_asset_uploader_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_cognito_presignup_trigger_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_cognito_presignup_trigger_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role" "lambda_cognito_post_confirmation_trigger_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_cognito_post_confirmation_trigger_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_cognito_post_authentication_trigger_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_cognito_post_authentication_trigger_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_cognito_userpool_client_settings_role" {
  name               = "${var.RESOURCE_PREFIX}-lambda_cognito_userpool_client_settings_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_cognito_userpool_domain_role" {
  name               = "${var.RESOURCE_PREFIX}-lambda_cognito_userpool_domain_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role" "lambda_dump_v3_account_role" {
  name = "${var.RESOURCE_PREFIX}-lambda_dump_v3_account_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role" "lambda_usergroup_importer_role" {
  name               = "${var.RESOURCE_PREFIX}-lambda_usergroup_importer_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role" "lambda_cloudfront_security_role" {
  name               = "${var.RESOURCE_PREFIX}-lambda_cloudfront_security_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com","edgelambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}



resource "aws_iam_role" "cognito_admin_group_role" {
  name = "${var.RESOURCE_PREFIX}-CognitoAdminRole-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": {"Federated": "cognito-identity.amazonaws.com"},
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {"cognito-identity.amazonaws.com:aud": "${var.COGNITO_IDENTITY_POOL}"},
            "ForAnyValue:StringLike": {"cognito-identity.amazonaws.com:amr": "authenticated"}
        }
    }
}
EOF
}


resource "aws_iam_role" "cognito_registered_group_role" {
  name = "${var.RESOURCE_PREFIX}-CognitoRegisteredRole-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": {"Federated": "cognito-identity.amazonaws.com"},
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {"cognito-identity.amazonaws.com:aud": "${var.COGNITO_IDENTITY_POOL}"},
            "ForAnyValue:StringLike": {"cognito-identity.amazonaws.com:amr": "authenticated"}
        }
    }
}
EOF
}


resource "aws_iam_role" "api_key_authoriser_invocation_role" {
  name               = "${var.RESOURCE_PREFIX}-api-key-authoriser_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}