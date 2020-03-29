from botocore.exceptions import ClientError
from flask import request, session
from flask_login import current_user, login_required

from flask_app import app
from flask_app import cognito_client, sqs_client
from flask_app.settings import AwsCognitoConfig, AwsSqsConfig


@app.route('/')
def index():
    return 'flask app'


@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return f'You are already logged in as a {current_user.username}'
    if request.method == 'POST':
        try:
            response = cognito_client.admin_initiate_auth(
                UserPoolId=AwsCognitoConfig.USER_POOL_ID,
                ClientId=AwsCognitoConfig.CLIENT_ID,
                AuthFlow='ADMIN_USER_PASSWORD_AUTH',
                AuthParameters={
                    'USERNAME': request.form['username'],
                    'PASSWORD': request.form['password']
                }
            )
        except ClientError as exc:
            app.logger.error(exc)
            return "Invalid credentials"

        # add AccessToken from Cognito to flask session
        session['AccessToken'] = response['AuthenticationResult']['AccessToken']
        return "You have been logged in"

    return """
        <div>
          <h2>Login to your account</h2>
          <form method="POST">
            <input type="text" name="username" placeholder="username" />
            <input type="password" name="password" placeholder="password" />
            <button type="submit">Login</button>
          </form>
        </div>
    """


@app.route("/protected")
@login_required
def page_with_login():
    return f"Logged in! Hi, {current_user.username}"


@app.route("/queue")
def send_message_to_queue():
    try:
        response = sqs_client.send_message(
            QueueUrl=AwsSqsConfig.URL,
            MessageBody='New message is ready'
        )
    except ClientError as exc:
        app.logger.error(exc)
        return 'Could not send a message to SQS'
    return f'Message with id {response["MessageId"]} has been successfully sent to SQS'
