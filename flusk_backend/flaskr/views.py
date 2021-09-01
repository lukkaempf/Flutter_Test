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


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']

        if not token:
            return jsonify({'message': 'token is missing'}), 403

        try:
            data = jwt.decode(token, secondsecretkey)
            current_user = Users.query.filter_by(username=data['username']).first()
        except:
            return jsonify({'message':'token is invalid'}), 403
        return f(current_user, *args, **kwargs)
    return decorated


@views.route('/api/login/', methods=['GET','POST'])
def home():
    if request.method == 'POST':
        requestdata = (request.form).to_dict(flat=False)
        username = ''.join(requestdata['username'])
        passwort = ''.join(requestdata['password'])
        user = db.session.query(Users).filter(Users.username==username).first()
        if user:
            if passwort == user.password:
                token = jwt.encode({'username':user.username,"exp": datetime.now() + timedelta(minutes=30)}, secondsecretkey)
                return jsonify({'token': token.decode('UTF-8')})
            return jsonify({'message':'Benutzername oder Passwort falsch'})
        return jsonify({'message':'Benutzername oder Passwort falsch'})
    return jsonify({'message':'test'})

@views.route('/api/test/')
@token_required
def test(current_user):
    return jsonify({'message':current_user.username})