resource "aws_cognito_user_pool" "flask_app" {
  name = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "flask_app" {
  name                 = var.user_pool_client_name
  user_pool_id         = aws_cognito_user_pool.flask_app.id
  generate_secret      = false
  explicit_auth_flows  = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}