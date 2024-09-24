from flask import Flask, Response, request, jsonify, render_template
import queue
import threading
import base64
import hashlib
import socket

app = Flask(__name__)

all_messages = []
clients = []
clients_lock = threading.Lock()
connected_clients = []

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

def handle_client(client_socket):
    global connected_clients
    connected_clients.append(client_socket)

    request = client_socket.recv(1024).decode()
    headers = request.split('\r\n')
    
    for header in headers:
        if 'Sec-WebSocket-Key' in header:
            websocket_key = header.split(": ")[1]
            break
    
    websocket_accept = base64.b64encode(
        hashlib.sha1((websocket_key.strip() + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11").encode()).digest()
    ).decode('utf-8')
    
    handshake_response = (
        'HTTP/1.1 101 Switching Protocols\r\n'
        'Upgrade: websocket\r\n'
        'Connection: Upgrade\r\n'
        f'Sec-WebSocket-Accept: {websocket_accept}\r\n\r\n'
    )
    client_socket.send(handshake_response.encode())
    
    try:
        while True:
            frame = client_socket.recv(1024)
            if not frame:
                break

            payload_length = frame[1] & 127
            if payload_length == 126:
                mask_start = 4
            elif payload_length == 127:
                mask_start = 10
            else:
                mask_start = 2
            
            masks = frame[mask_start:mask_start+4]
            message = frame[mask_start+4:]
            decoded_message = ''.join(
                [chr(message[i] ^ masks[i % 4]) for i in range(len(message))]
            )
            
            print(f"Received message: {decoded_message}")

            broadcast_message(decoded_message)
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        connected_clients.remove(client_socket)
        client_socket.close()

def broadcast_message(message):
    global connected_clients
    response = bytearray()
    response.append(129)
    response.append(len(message)) 
    response.extend(message.encode('utf-8'))

    for client in connected_clients:
        try:
            client.send(response)
        except Exception as e:
            print(f"Failed to send message to a client: {e}")

def start_websocket_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('localhost', 5001))
    server_socket.listen(5)
    print("WebSocket server started on ws://localhost:5001")

    while True:
        client_socket, addr = server_socket.accept()
        print(f"Connection from {addr}")
        threading.Thread(target=handle_client, args=(client_socket,)).start()

threading.Thread(target=start_websocket_server).start()

if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)
