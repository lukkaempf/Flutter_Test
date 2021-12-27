from . import db
from sqlalchemy import text
import json
from dataclasses import dataclass
from collections import OrderedDict
from sqlalchemy.sql import func
import datetime

user_picture = db.Table('user_picture',
    db.Column('user_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('picture_id', db.Integer, db.ForeignKey('picture.id'))
)

user_society = db.Table('user_society',
    db.Column('user_id', db.Integer, db.ForeignKey('user.id')),
    db.Column('society_id', db.Integer, db.ForeignKey('society.id')),
    db.Column('date_created', db.DateTime, server_default=func.now())
)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50))
    email = db.Column(db.String(50))
    firstname = db.Column(db.String(50))
    name = db.Column(db.String(50))
    password = db.Column(db.String(200))
    users = db.relationship('Picture', secondary=user_picture, backref=db.backref('users', lazy='dynamic'))

    def to_dict(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}

@dataclass
class Society(db.Model):
    id: int
    name: str
    description: str
    image_path: str
    date_created: datetime
    date_last_updated: datetime

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    description = db.Column(db.String(100))
    image_path = db.Column(db.String(200))
    date_created = db.Column(db.DateTime, server_default=func.now())
    date_last_updated = db.Column(db.TIMESTAMP, server_default=text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))
    

@dataclass
class Picture(db.Model):
    id: int
    name: str
    path: str
    size: str

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    path = db.Column(db.String(500))
    size = db.Column(db.Integer)
   
    def to_dict(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}
