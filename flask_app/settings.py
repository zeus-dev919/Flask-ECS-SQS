import configparser
from pathlib import Path

config_path = Path(__file__).parent / 'config.ini'

settings = configparser.ConfigParser()
with open(config_path) as ini_file:
    settings.read_file(ini_file)


class AwsSqsConfig:
    NAME = settings['awssqs']['name']
    URL = ''


class AwsCognitoConfig:
    USER_POOL_ID = ''
    CLIENT_ID = ''
    USER_POOL_NAME = settings['awscognito']['user_pool_name']
    USER_POOL_CLIENT_NAME = settings['awscognito']['user_pool_client_name']
    USER = {
        'name': settings['awscognito']['username'],
        'password': settings['awscognito']['user_password']
    }
