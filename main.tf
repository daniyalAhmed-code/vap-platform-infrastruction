locals {
  RESOURCE_PREFIX                 = "vap-${lower(var.ENV)}"
  DEV_PORTAL_SITE_S3_BUCKET       = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_SITE_S3_BUCKET_NAME
  ARTIFICATS_S3_BUCKET            = data.terraform_remote_state.vap-platform-infra.outputs.ARTIFACT_S3_BUCKET_NAME
  DEV_PORTAL_CUSTOMERS_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  DEV_PORTAL_CUSTOMERS_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_CUSTOMERS_TABLE_ARN

  DEV_PORTAL_FEEDBACK_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_FEEDBACK_TABLE_NAME
  DEV_PORTAL_FEEDBACK_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_FEEDBACK_TABLE_ARN

  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN  = data.terraform_remote_state.vap-platform-infra.outputs.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN
  BUCKET_REGIONAL_DOMAIN_NAME              = data.terraform_remote_state.vap-platform-infra.outputs.BUCKET_REGIONAL_DOMAIN_NAME
  TOPIC_NAME                               = data.terraform_remote_state.vap-platform-infra.outputs.TOPIC_NAME
  COGNITO_USER_POOL                        = "${local.RESOURCE_PREFIX}-user-pool"
  COGNITO_USER_POOL_CLIENT                 = "${local.RESOURCE_PREFIX}-user-pool-client"

  ENABLE_FEEDBACK_SUBMISSION = var.ENABLE_FEEDBACK_SUBMISSION == "admin@email.com" ? local.TOPIC_NAME : ""
  IS_ADMIN                   = var.ENABLE_FEEDBACK_SUBMISSION == "admin@email.com" ? true : false

  USE_CUSTOM_DOMAIN_NAME = var.CUSTOM_DOMAIN_NAME != "" && var.ACM_CERTIFICATE_ARN != "" ? "https://${var.CUSTOM_DOMAIN_NAME}" : null
  CORS_ALLOW_ORIGIN      = "*"
  AWS_REGION             = data.aws_region.current.name
  CURRENT_ACCOUNT_ID     = data.aws_caller_identity.current.account_id

  REGISTERED_GROUP_NAME = "${local.RESOURCE_PREFIX}-registered-group"
  ADMIN_GROUP_NAME      = "${local.RESOURCE_PREFIX}-admin-group"

}

module "role" {
  source                = "./modules/role"
  COGNITO_IDENTITY_POOL = module.cognito.COGNITO_IDENTITY_POOL
  RESOURCE_PREFIX       = local.RESOURCE_PREFIX
}

module "policy" {
  source = "./modules/policy"
  providers = {
    aws.src    = aws
    aws.global = aws.global_region
  }
  CLOUDFRONT_SECURITY_LAMBDA_QUALIFIED_ARN             = module.lambda.CLOUDFRONT_SECURITY_LAMBDA_QUALIFIED_ARN
  COGNITO_USER_POOL                                    = module.cognito.COGNITO_USERPOOL_ARN
  LAMBDA_CATALOG_UPDATER_ROLE_NAME                     = module.role.LAMBDA_CATALOG_UPDATER_ROLE_NAME
  LAMBDA_BACKEND_ROLE_NAME                             = module.role.LAMBDA_BACKEND_ROLE_NAME
  LAMBDA_ASSET_UPLOADER_ROLE_NAME                      = module.role.LAMBDA_ASSET_UPLOADER_ROLE_NAME
  CUSTOMER_TABLE_ARN                                   = local.DEV_PORTAL_CUSTOMERS_TABLE_ARN
  CUSTOMER_TABLE_NAME                                  = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  PRE_LOGIN_TABLE_ARN                                  = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN
  AWS_REGION                                           = local.AWS_REGION
  CURRENT_ACCOUNT_ID                                   = local.CURRENT_ACCOUNT_ID
  RESOURCE_PREFIX                                      = local.RESOURCE_PREFIX
  WEBSITE_BUCKET_NAME                                  = local.DEV_PORTAL_SITE_S3_BUCKET
  ARTIFACTS_S3_BUCKET_NAME                             = local.ARTIFICATS_S3_BUCKET
  CATALOG_UPDATER_LAMBDA_NAME                          = module.lambda.CATALOG_UPDATER_LAMBDA_NAME
  LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME           = module.role.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME = module.role.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME   = module.role.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_NAME
  LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME     = module.role.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_NAME
  LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME             = module.role.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_NAME
  LAMBDA_USERGROUP_IMPORTER_ROLE_NAME                  = module.role.LAMBDA_USERGROUP_IMPORTER_ROLE_NAME
  LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME                     = module.role.LAMBDA_DUMP_V3_ACCOUNT_ROLE_NAME
  LAMBDA_COGNITO_PRE_SIGNUP_NAME                       = module.lambda.COGNITO_PRESIGNUP_TRIGGER_LAMBDA_NAME
  LAMBDA_COGNITO_POST_CONFIRMATION_NAME                = module.lambda.COGNITO_POST_CONFIRMATION_TRIGGER_LAMBDA_NAME
  LAMBDA_COGNITO_POST_AUTHENTICATION_NAME              = module.lambda.COGNITO_POST_AUTHENTICATION_TRIGGER_LAMBDA_NAME
  LAMBDA_CLOUDFRONT_SECURITY                           = module.lambda.CLOUDFRONT_SECURITY_LAMBDA_NAME
  LAMBDA_SECURITY_HEADER                               = module.lambda.CLOUDFRONT_SECURITY_HEADER_NAME
  USERPOOL_ID                                          = module.cognito.COGNITO_USER_POOL
  API_GATEWAY_API                                      = module.api.API_GATEWAY_API
  COGNITO_ADMIN_GROUP_ROLE                             = module.role.COGNITO_ADMIN_GROUP_ROLE_NAME
  COGNITO_REGISTERED_GROUP_ROLE                        = module.role.COGNITO_REGISTERED_GROUP_ROLE_NAME
  LAMBDA_CLOUDFRONT_SECURITY_ROLE                      = module.role.CLOUDFRONT_SECURITY_ROLE_NAME
  ORIGIN_ACCESS_IDENTITY                               = module.cloudfront.id
  API_KEY_AUTHORIZATION_LAMBDA_ARN                     = module.lambda.API_KEY_AUTHORIZATION_LAMBDA_ARN
  API_KEY_AUTHORIZATION_ROLE_NAME                      = module.role.API_KEY_AUTHORIZATION_ROLE_NAME
  CATALOG_UPDATER_LAMBDA_ARN                           = module.lambda.CATALOG_UPDATER_LAMBDA_ARN
  COGNITO_SMS_CALLER_ROLE_NAME                         = module.role.SMS_CALLER_ROLE_NAME
}

module "lambda" {
  source = "./modules/lambda"
  providers = {
    aws.src    = aws
    aws.global = aws.global_region
  }
  ARTIFACTS_S3_BUCKET_NAME                            = local.ARTIFICATS_S3_BUCKET
  LAMBDA_CATALOG_UPDATER_ROLE_ARN                     = module.role.LAMBDA_CATALOG_UPDATER_ROLE_ARN
  LAMBDA_BACKEND_ROLE_ARN                             = module.role.LAMBDA_BACKEND_ROLE_ARN
  LAMBDA_ASSET_UPLOADER_ROLE_ARN                      = module.role.LAMBDA_ASSET_UPLOADER_ROLE_ARN
  LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN           = module.role.LAMBDA_COGNITO_PRESIGNUP_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN = module.role.LAMBDA_COGNITO_POST_AUTHENTICATION_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN   = module.role.LAMBDA_COGNITO_POST_CONFIRMATION_TRIGGER_ROLE_ARN
  LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN     = module.role.LAMBDA_COGNITO_USERPOOL_CLIENT_SETTING_ROLE_ARN
  LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN             = module.role.LAMBDA_COGNITO_USERPOOL_DOMAIN_ROLE_ARN
  LAMBDA_USERGROUP_IMPORTER_ROLE_ARN                  = module.role.LAMBDA_USERGROUP_IMPORTER_ROLE_ARN
  LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN                     = module.role.LAMBDA_DUMP_V3_ACCOUNT_ROLE_ARN
  LAMBDA_CLOUDFRONT_SECURITY_ROLE_ARN                 = module.role.CLOUDFRONT_SECURITY_ROLE_ARN
  NODE_ENV                                            = var.NODE_ENV
  WEBSITE_BUCKET_NAME                                 = local.DEV_PORTAL_SITE_S3_BUCKET
  CUSTOMER_TABLE_NAME                                 = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  PRE_LOGIN_ACCOUNT_TABLE_NAME                        = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  FEEDBACK_TABLE_NAME                                 = local.DEV_PORTAL_FEEDBACK_TABLE_NAME
  FEEDBACK_SNS_TOPIC_ARN                              = local.ENABLE_FEEDBACK_SUBMISSION
  USERPOOL_ID                                         = module.cognito.COGNITO_USER_POOL
  IS_ADMIN                                            = local.IS_ADMIN
  ADMIN_GROUP_NAME                                    = local.ADMIN_GROUP_NAME
  RESOURCE_PREFIX                                     = local.RESOURCE_PREFIX
  ACCOUNT_REGISTRATION_MODE                           = var.ACCOUNT_REGISTRATION_MODE
  REGISTERED_GROUP_NAME                               = local.REGISTERED_GROUP_NAME
  DEVELOPMENT_MODE                                    = var.DEVELOPMENT_MODE ? true : false
  AWS_REGION                                          = data.aws_region.current.name
  API_GATEWAY_API                                     = module.api.API_GATEWAY_ID
  FEEDBACK_ENABLED                                    = local.IS_ADMIN
  USERPOOL_DOMAIN                                     = "https://${var.COGNITO_USER_POOL_DOMAIN}.auth.${data.aws_region.current.name}.amazoncognito.com"
  USERPOOL_CLIENT_ID                                  = module.cognito.COGNITO_USERPOOL_CLIENT
  IDENTITYPOOL_ID                                     = module.cognito.COGNITO_IDENTITY_POOL

}


module "api" {
  source                           = "./modules/api"
  RESOURCE_PREFIX                  = local.RESOURCE_PREFIX
  ENV                              = var.ENV
  CORS_ALLOW_ORIGIN                = local.CORS_ALLOW_ORIGIN
  BACKEND_LAMBDA_INVOKE_ARN        = module.lambda.BACKEND_LAMBDA_INVOKE_ARN
  BACKEND_LAMBDA_NAME              = module.lambda.BACKEND_LAMBDA_NAME
  USE_CUSTOM_DOMAIN_NAME           = local.USE_CUSTOM_DOMAIN_NAME
  DOMAIN_NAME                      = module.cloudfront.CLOUDFRONT_DOMAIN
  CURRENT_ACCOUNT_ID               = data.aws_caller_identity.current.account_id
  AWS_REGION                       = data.aws_region.current.name
  API_KEY_AUTHORIZATION_ROLE_ARN   = module.role.API_KEY_AUTHORIZATION_ROLE_ARN
  API_KEY_AUTHORIZATION_INVOKE_ARN = module.lambda.API_KEY_AUTHORIZATION_INVOKE_ARN

}

module "cloudfront" {
  source = "./modules/cloudfront"
  providers = {
    aws = aws.global_region
  }
  DEVELOPMENT_MODE                 = var.DEVELOPMENT_MODE
  RESOURCE_PREFIX                  = local.RESOURCE_PREFIX
  CUSTOM_DOMAIN_NAME               = var.CUSTOM_DOMAIN_NAME
  DEV_PORTAL_SITE_S3_BUCKET        = local.DEV_PORTAL_SITE_S3_BUCKET
  ARTIFACTS_S3_BUCKET_NAME         = local.ARTIFICATS_S3_BUCKET
  CLOUDFRONT_SECURITY_HEADER_SETUP = module.lambda.CLOUDFRONT_SECURITY_HEADER_QUALIFIED_ARN
  ORIGIN_ID                        = var.ORIGIN_ID
  AWS_REGION                       = data.aws_region.current.name
  ACM_CERTIFICATE_ARN              = var.ACM_CERTIFICATE_ARN
  BUCKET_REGIONAL_DOMAIN_NAME      = local.BUCKET_REGIONAL_DOMAIN_NAME

}

module "route53" {
  source             = "./modules/route53"
  USE_ROUTE53        = var.USE_ROUTE53
  CUSTOM_DOMAIN_NAME = var.CUSTOM_DOMAIN_NAME
  HOSTED_ZONE_ID     = var.HOSTED_ZONE_ID
  DNS_NAME           = module.cloudfront.CLOUDFRONT_DOMAIN
}


module "cognito" {
  source                               = "./modules/cognito"
  COGNITO_USER_POOL                    = local.COGNITO_USER_POOL
  ALLOW_ADMIN_CREATE_USER_ONLY         = var.ALLOW_ADMIN_CREATE_USER_ONLY
  CUSTOM_DOMAIN_NAME                   = var.CUSTOM_DOMAIN_NAME
  AWS_REGION                           = local.AWS_REGION
  AWS_ACCOUNT_ID                       = local.CURRENT_ACCOUNT_ID
  RESOURCE_PREFIX                      = local.RESOURCE_PREFIX
  COGNITO_USER_POOL_CLIENT             = local.COGNITO_USER_POOL_CLIENT
  COGNITO_ADMIN_GROUP_DESCRIPTION      = var.COGNITO_ADMIN_GROUP_DESCRIPTION
  COGNITO_REGISTERED_GROUP_DESCRIPTION = var.COGNITO_REGISTERED_GROUP_DESCRIPTION
  COGNITO_USER_POOL_DOMAIN             = var.COGNITO_USER_POOL_DOMAIN
  DNS_NAME                             = module.cloudfront.CLOUDFRONT_DOMAIN
  REGISTERED_GROUP_NAME                = local.REGISTERED_GROUP_NAME
  ADMIN_GROUP_NAME                     = local.ADMIN_GROUP_NAME
  # LOCAL_DEVELOPMENT_MODE = var.LOCAL_DEVELOPMENT_MODE
  COGNITO_REGISTERED_GROUP_ROLE_ARN = module.role.COGNITO_REGISTERED_GROUP_ROLE_ARN
  COGNITO_ADMIN_GROUP_ROLE_ARN      = module.role.COGNITO_ADMIN_GROUP_ROLE_ARN
  # BUCEKT_REGIONAL_DOMAIN_NAME = var.BUCKET_REGIONAL_NAME
  COGNITO_SMS_CALLER_ROLE           = module.role.SMS_CALLER_ROLE_NAME
}

module "policy_invoke_lambda" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.5.0"
  name    = "invoke-lambda-policy"
  path    = "/"
  //  description = "My example policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:invokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "lambda_execution_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "4.5.0"
  create_role       = true
  role_name         = "apigateway-lambda-execution-role"
  role_requires_mfa = false
  trusted_role_services = [
    "apigateway.amazonaws.com"
  ]
  custom_role_policy_arns = [
    module.policy_invoke_lambda.arn
  ]
  number_of_custom_role_policy_arns = 1
}

### Give Lambda Permission ###
resource "aws_lambda_permission" "device_type_lambda" {
  function_name = data.terraform_remote_state.st_connector.outputs.device_type_lambda_name
  statement_id  = "APIGatewayAny"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.arn}/*/*/*"
}

data "terraform_remote_state" "st_connector" {
  backend = "s3"
  config = {
    bucket = "vap-aws-terraform-remote-state-centralized"
    key    = "vap-st-connector/${data.aws_region.current.name}/${var.ENV}/terraform.tfstate"
    region = data.aws_region.current.name
  }
}

data "template_file" "swagger" {
  template = file("./templates/swagger.yaml")
  vars = {
    REGION                 = data.aws_region.current.name
    DEVICE_TYPE_LAMBDA_ARN = data.terraform_remote_state.st_connector.outputs.device_type_lambda_arn
    EXECUTION_ROLE_ARN     = module.lambda_execution_role.iam_role_arn
  }
}

resource "aws_api_gateway_rest_api" "this" {
  name = var.NAME
  body = data.template_file.swagger.rendered
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = "Deployed By Terraform"
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = var.ENV
  //  description   = ""
  //  dynamic "access_log_settings" {
  //    for_each = var.enable_access_logs ? [1] : []
  //    content {
  //      destination_arn = aws_cloudwatch_log_group.access[0].arn
  //      format = jsonencode({
  //        "requestId" : "$context.requestId",
  //        "ip" : "$context.identity.sourceIp",
  //        "caller" : "$context.identity.caller",
  //        "user" : "$context.identity.user",
  //        "requestTime" : "$context.requestTime",
  //        "httpMethod" : "$context.httpMethod",
  //        "requestPath" : "$context.path",
  //        "resourcePath" : "$context.resourcePath",
  //        "status" : "$context.status",
  //        "protocol" : "$context.protocol",
  //        "responseLength" : "$context.responseLength"
  //      })
  //    }
  //  }
  //  tags = var.tags
}
