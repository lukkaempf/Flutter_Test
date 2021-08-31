from flask import Blueprint, request, jsonify
import jwt
from datetime import datetime
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
        token = request.args.get('token')
        if not token:
            return jsonify({'message': 'token is missing'}), 403
        try:
            data = jwt.decode(token, secondsecretkey)
        except:
            return jsonify({'message':'token is invalid'}), 403
        return f(*args, **kwargs)
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
                token = jwt.encode({'user':user.username,"exp": datetime.now()}, secondsecretkey)
                return jsonify({'token': token.decode('UTF-8')})
    return jsonify(
        color='bamboo',
        left_handed=True,
    )

@views.route('/api/test/')
@token_required
def test():
    return jsonify({'message':'erfolgreich'}), 200