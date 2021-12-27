from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:sml12345@localhost/flutter_test'
    app.config['SECRET_KEY'] = 'donthack'

    from .views import views
    app.register_blueprint(views, url_prefix='/')

    db.init_app(app)
    db.create_all(app=app)


    return app

