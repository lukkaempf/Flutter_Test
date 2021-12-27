from flaskr import create_app
from werkzeug.serving import WSGIRequestHandler

app = create_app()

if __name__ == '__main__':
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(debug=True)
