from flask import Flask, Response, request, jsonify, render_template
from flask_socketio import SocketIO, send
import queue
import threading

app = Flask(__name__)
socketio = SocketIO(app)

all_messages = []

clients = []
clients_lock = threading.Lock()

# SSE Event Stream
def event_stream(client_queue):
    while True:
        try:
            message = client_queue.get()
            yield f"data: {message}\n\n"
        except GeneratorExit:
            break

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/sse')
def sse_page():
    return render_template('sse.html')

@app.route('/websocket')
def websocket_page():
    return render_template('websocket.html')

@app.route('/stream')
def stream():
    client_queue = queue.Queue()
    with clients_lock:
        clients.append(client_queue)
    return Response(event_stream(client_queue), content_type='text/event-stream')

@app.route('/messages', methods=['GET'])
def get_messages():
    return jsonify(all_messages)

@app.route('/send', methods=['POST'])
def send_message():
    message = request.json.get('message', '').strip()
    if not message:
        return jsonify(success=False, error="Message cannot be empty"), 400
    full_message = f"Message Sent: {message}"
    all_messages.append(full_message)
    with clients_lock:
        for client_queue in clients:
            client_queue.put(full_message)
    return jsonify(success=True)

# WebSocket event handler
@socketio.on('message')
def handle_websocket_message(message):
    full_message = f"WebSocket Message: {message}"
    all_messages.append(full_message)
    send(full_message, broadcast=True)  # Broadcast the message to all connected clients

# if __name__ == '__main__':
#     socketio.run(app, debug=True, threaded=True)

if __name__ == '__main__':
    socketio.run(app, debug=True)
