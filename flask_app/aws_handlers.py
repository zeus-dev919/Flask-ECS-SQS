from flask_app import cognito_client
from flask_app import sqs_client
from flask_app.settings import AwsCognitoConfig
from flask_app.settings import AwsSqsConfig


def set_user_pool_id():
    response = cognito_client.list_user_pools(
        MaxResults=5
    )
    AwsCognitoConfig.USER_POOL_ID = [
        user_pool['Id']
        for user_pool in response['UserPools']
        if user_pool['Name'] == AwsCognitoConfig.USER_POOL_NAME
    ][0]


def set_user_pool_client_id():
    response = cognito_client.list_user_pool_clients(
        UserPoolId=AwsCognitoConfig.USER_POOL_ID
    )
    AwsCognitoConfig.CLIENT_ID = [
        user_pool_client['ClientId']
        for user_pool_client in response['UserPoolClients']
        if user_pool_client['ClientName'] == AwsCognitoConfig.USER_POOL_CLIENT_NAME
    ][0]


def create_user_pool_test_user():
    try:
        cognito_client.admin_create_user(
            UserPoolId=AwsCognitoConfig.USER_POOL_ID,
            Username=AwsCognitoConfig.USER['name']
        )
        cognito_client.admin_set_user_password(
            UserPoolId=AwsCognitoConfig.USER_POOL_ID,
            Username=AwsCognitoConfig.USER['name'],
            Password=AwsCognitoConfig.USER['password'],
            Permanent=True
        )
    except cognito_client.exceptions.UsernameExistsException:
        pass


def set_sqs_url():
    response = sqs_client.get_queue_url(
        QueueName=AwsSqsConfig.NAME
    )
    AwsSqsConfig.URL = response['QueueUrl']
