from . import db

class Users(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50))
    email = db.Column(db.String(50))
    firstname = db.Column(db.String(50))
    name = db.Column(db.String(50))
    password = db.Column(db.String(200))