from flask import Flask, jsonify
import time

app = Flask(__name__)


@app.route('/')
def get_epoch_time():
    return jsonify({"The current epoch time": int(time.time())})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
