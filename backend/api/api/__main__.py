from flask import request, jsonify
from config import app, db

@app.route("/", methods=["GET"])
def home():
    return "Hello, World!"

@app.route("/users", methods=["GET"])
def users():
    from models import User

    users = User.query.all()
    json_users = map(lambda x: x.to_json(), users)

    return jsonify({"users": json_users})

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
        print("Database created!")

    app.run(debug=True)
