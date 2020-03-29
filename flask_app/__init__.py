import boto3
import logging
from flask import Flask
from flask_login import LoginManager

from flask_app.settings import settings


cognito_client = boto3.client('cognito-idp')
sqs_client = boto3.client('sqs')
login_manager = LoginManager()

app = Flask(__name__)
app.secret_key = settings['app']['secret_key']
app.logger.setLevel(logging.INFO)
login_manager.init_app(app)

import flask_app.views
import flask_app.auth
from flask_app.aws_handlers import set_user_pool_id, set_user_pool_client_id, create_user_pool_test_user, set_sqs_url


@app.before_first_request
def set_initial_variables():
    try:
        set_user_pool_id()
        set_user_pool_client_id()
        create_user_pool_test_user()
        set_sqs_url()
    except Exception as exc:
        app.logger.error(exc)
        app.logger.error('Unable to set initial AWS configuration')
