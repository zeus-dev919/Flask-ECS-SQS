from flask import session
from flask_login import UserMixin

from flask_app import login_manager, cognito_client


@login_manager.request_loader
def get_user_from_cognito(request):
    try:
        response = cognito_client.get_user(
            AccessToken=session['AccessToken']
        )
        username = response['Username']
        return User(username)
    except Exception:
        return None


class User(UserMixin):
    def __init__(self, username):
        self.username = username
