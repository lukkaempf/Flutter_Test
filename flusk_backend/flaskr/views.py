from flask import Blueprint, request, jsonify, make_response
import jwt
from datetime import datetime, timedelta
import json
from . import db
from .models import User, Picture, user_picture, Society, user_society
from werkzeug.datastructures import ImmutableMultiDict
from functools import wraps
from PIL import Image, ExifTags
from PIL.ExifTags import TAGS
import tempfile
import os
import base64

views= Blueprint('views', __name__)

secondsecretkey = 'donthack'
filepath = 'flaskr/data/pictures/'

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
            current_user = User.query.filter_by(username=data['username']).first()
        except:
            return jsonify({'message':'token is invalid'}), 403
        return f(current_user, *args, **kwargs)
    return decorated

@views.route('/')
def start():
    return 'Flutter Test API'

@views.route('/api/login', methods=['GET','POST'])
def home():
    if request.method == 'POST':
        requestdata = (request.form).to_dict(flat=False)
        username = ''.join(requestdata['username'])
        passwort = ''.join(requestdata['password'])
        print(username)
        if not username or not passwort:
            return jsonify({'message':'Geben Sie eine Email and Passwort ein.'}), 403
        
        user = db.session.query(User).filter(User.username==username).first()
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

        isuserexisting = db.session.query(User).filter(User.username==requestdata('Benutzername')).first()
        if not isuserexisting:
            newuser = User(username=requestdata('Benutzername'), email=requestdata('Mail'), firstname=requestdata('Vorname'), name=requestdata('Name'), password=requestdata('Passwort'))
            db.session.add(newuser)
            db.session.commit()
            return jsonify({'message':'erfolgreich'})

       
            
        return jsonify({'errorBenutzername':'Benutzername bereits in Verwendung'})
    return jsonify({'message':''})

@views.route('api/upload/', methods=['GET','POST'])
@token_required
def upload(current_user):
    requestdata = request.files.getlist('image')
    print(requestdata)
    for r in requestdata:
        metadata = {}
        path = (filepath+r.filename)
        
        r.save(path)

        img = Image.open(path)
        for tag, value in img._getexif().items():
            if tag in TAGS:
             metadata[TAGS[tag]] = value
        print(metadata)

        result = {
                #"id": unicode(r.id),
                "size": os.path.getsize(path),
                "file_name": r.filename,
                "path" : path,
                "current_user" : current_user.id,
                #"url": FileStorage.get_url(file_obj, current_app.config)
            }
        print(result)

        user = db.session.query(User).filter(User.id==current_user.id).first()
        print(user.name)

        new_picture = Picture(name=result['file_name'],path=result['path'],size=result['size'])
        db.session.add(new_picture)
        new_picture.users.append(user)
        db.session.commit()
        
    return ({'message':'erfolgreich'})

@views.route('api/collection/')
@token_required
def collection(current_user):
    
    #Left Join
    #all = db.session.query(Picture).join(user_picture, isouter=True).all()

    picturesInCollectionFromDatabase = db.session.query(Picture).join(user_picture).join(User).filter(User.id==current_user.id).all()
   
    #test1 = db.session.query(User).filter(User.username=='admin').first().to_dict()

    #with open ('test1.jpg', 'wb') as f:
     #   f.write(encoded_string)

    return jsonify(picturesInCollectionFromDatabase)




@views.route('api/picture/<picturepath>/')
#@token_required
def getpicture(picturepath):
    try:
        with open(filepath + picturepath, "rb") as image_file:
            encoded_string = image_file.read()
    except:
        return jsonify({'message': 'file not found'})
    return encoded_string






@views.route('api/society/', methods=['GET'])
@token_required
def showSociety(current_user):
    getSocietys = db.session.query(Society).join(user_society).filter_by(user_id=current_user.id).all()
    return jsonify(getSocietys)

@views.route('api/society/', methods=['POST'])
@token_required
def createSociety(current_user):
    if request.method=='POST':
        requestdata = (request.form).to_dict(flat=False)
        name = ''.join(requestdata['name'])
        description = ''.join(requestdata['description'])
        image = request.files.getlist('image')

        for i in image:
            path = (filepath+i.filename)
            i.save(path)

        user = db.session.query(User).filter(User.id==current_user.id).first()

        newSociety = Society(name=name, description=description, image_path=path)
        db.session.add(newSociety)
        db.session.commit()

        #INSERT INTO LINKTABLE
        newUser_Society = user_society.insert().values(user_id=user.id, society_id=newSociety.id)
        db.session.execute(newUser_Society)
        db.session.commit()

        return jsonify({'message':'success'})
    return jsonify({})

@views.route('api/society/<societyid>/', methods=['PATCH'])
@token_required
def patchSociety(current_user, societyid):
    if request.method=='PATCH':
        requestdata = (request.form).to_dict(flat=False)
        name = ''.join(requestdata['name'])
        description = ''.join(requestdata['description'])
        image = request.files.getlist('image')

        currentSociety = db.session.query(Society).filter_by(id=societyid).first()
        if currentSociety: 
            if image: 
                for i in image:
                    path = (filepath+i.filename)
                    i.save(path)
                os.remove(currentSociety.image_path)
                currentSociety.image_path = path
            if name:
                currentSociety.name = name
            if description:
                currentSociety.description = description
            db.session.commit()
            return jsonify({'message':'success'})
        else:
            return jsonify({'message':'society not found'})
    return jsonify({})

@views.route('api/society/<societyid>/', methods=['DELETE'])
@token_required
def deleteSociety(current_user, societyid):
    if request.method=='DELETE':
        currentSociety = db.session.query(Society).filter_by(id=societyid).first()
        if currentSociety:
            try:
                os.remove(currentSociety.image_path)
                db.session.query(user_society).filter_by(society_id=currentSociety.id).delete()
                db.session.delete(currentSociety)
                db.session.commit()
                return jsonify({'message':'success'})
            except:
                return jsonify({'message':'failed'})   
        else:
            return jsonify({'message':'society not found'})
    return jsonify({})