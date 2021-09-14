from flask import Blueprint, request, jsonify
import jwt
from datetime import datetime, timedelta
import json
from . import db
from .models import Users
from werkzeug.datastructures import ImmutableMultiDict
from functools import wraps

views= Blueprint('views', __name__)

secondsecretkey = 'donthack'

def check_token(token):
    token_decode = jwt.decode(token, secondsecretkey)
    return token_decode



def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']

        if not token:
            return jsonify({'message': 'token is missing'}), 403

        try:
            data = check_token(token)
            current_user = Users.query.filter_by(username=data['username']).first()
        except:
            return jsonify({'message':'token is invalid'}), 403
        return f(current_user, *args, **kwargs)
    return decorated


@views.route('/api/login', methods=['GET','POST'])
def home():
    if request.method == 'POST':
        requestdata = (request.form).to_dict(flat=False)
        username = ''.join(requestdata['username'])
        passwort = ''.join(requestdata['password'])
        print(username)
        if not username and not passwort:
            return jsonify({'message':'Geben Sie eine Email and Passwort ein.'}), 403
        
        user = db.session.query(Users).filter(Users.username==username).first()
        if user:
            if passwort == user.password:
                token = jwt.encode({'username':user.username,"exp": datetime.now() + timedelta(minutes=30)}, secondsecretkey)
                return jsonify({'token': token.decode('UTF-8')})
            return jsonify({'message':'Benutzername oder Passwort falsch.'}), 403
        return jsonify({'message':'Benutzername oder Passwort falsch.'}), 403
    return jsonify(
        color='bamboo',
        left_handed=True
    )

@views.route('/api/test/')
@token_required
def test(current_user):
    return jsonify({'message':current_user.username})