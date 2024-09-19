from flask import Flask, Response, request, jsonify, render_template
import queue

app = Flask(__name__)
messages = queue.Queue()

def event_stream():
    while True:
        message = messages.get()  # Wait for a message
        yield f"data: {message}\n\n"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/stream')
def stream():
    return Response(event_stream(), content_type='text/event-stream')

@app.route('/send', methods=['POST'])
def send():
    message = request.json.get('message', '')
    messages.put(f"Message Sent: {message}")
    return jsonify(success=True)

if __name__ == '__main__':
    app.run(debug=True, threaded=True)
