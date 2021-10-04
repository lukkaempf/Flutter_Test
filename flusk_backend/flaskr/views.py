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
        if not username or not passwort:
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

@views.route('/api/signup', methods=['GET','POST'])
def signup():
    if request.method == 'POST':
        requestdata = request.form.getlist

        firstname=''.join(requestdata('Vorname'))
        name=''.join(requestdata('Name'))
        email=''.join(requestdata('Mail'))
        username=''.join(requestdata('Benutzername'))
        password=''.join(requestdata('Passwort'))
        password2=''.join(requestdata('Passwort2'))

        if not firstname or not name or not email or not username or not password or not password2:
            return jsonify({'errorAll':'nicht alle Felder ausgefüllt'})


        if not requestdata('Passwort') == requestdata('Passwort2'):
            return jsonify({'errorPasswort':'Passwörter stimmen nicht überein'})

        isuserexisting = db.session.query(Users).filter(Users.username==requestdata('Benutzername')).first()
        if not isuserexisting:
            newuser = Users(username=requestdata('Benutzername'), email=requestdata('Mail'), firstname=requestdata('Vorname'), name=requestdata('Name'), password=requestdata('Passwort'))
            db.session.add(newuser)
            db.session.commit()
            return jsonify({'message':'erfolgreich'})

       
            
        return jsonify({'errorBenutzername':'Benutzername bereits in Verwendung'})
    return jsonify({'message':''})

@views.route('/api/test/')
@token_required
def test(current_user):
    return jsonify({'message':current_user.username})
