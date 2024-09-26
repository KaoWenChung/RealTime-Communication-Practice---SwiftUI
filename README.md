# Real-Time Message System

## Overview
This project implements a real-time messaging system with two real-time communication technologies: **WebSocket** and **Server-Sent Events (SSE)**. It includes:
- A Python Flask-based server.
- A simple HTML web client for interacting with the server in real-time.
- A SwiftUI mobile client for iOS devices.

Both the web and mobile clients allow sending and receiving messages in real-time.

## Features
- **Send Messages**: Users can send messages through either the web or mobile interface.
- **Real-Time Updates**: All connected clients (both web and mobile) receive message updates in real-time.
  - **WebSocket**: Enables full-duplex communication between the server and clients.
  - **SSE**: Pushes updates from the server to clients using one-way communication.
  
## Tech Stack
- **Backend**: Flask (Python)
- **iOS app**: SwiftUI (Swift)
- **Frontend**: HTML, JavaScript
- **Communication**: 
  - **WebSocket** for full-duplex communication.
  - **Server-Sent Events (SSE)** for real-time server updates to clients.
  
## Setup and Installation

### Prerequisites
- Python 3.6 or higher
- Flask

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/KaoWenChung/RealTime-Communication-Practice-SwiftUI.git
   cd RealTime-Communication-Practice-SwiftUI/web_server
   ```

2. Set up a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install the requirements:
   ```bash
   pip3 install -r requirements.txt
   ```

4. Run the Flask server:
   ```bash
   python3 app.py
   ```

### Accessing the Application

#### Web Client:
Open your web browser and navigate to `http://127.0.0.1:5000/` to see the web client in action.

#### iOS Mobile Client:
The iOS client is built using **SwiftUI**. To use the mobile client:
1. Open the `SwiftUI` project in Xcode.
2. Run the app on a simulator.
3. Ensure the mobile client connects to the same WebSocket or SSE server.

## Usage
- **Sending a Message**:
  - On the **Web Client**: Enter a message in the input field and click the "Send Message" button.
  - On the **Mobile Client**: Type the message and submit using the provided interface.
  
  The message will be broadcast to all connected clients (both web and mobile).
  
- **Viewing Messages**: All messages sent by any user will appear in real-time on both the web and mobile clients.

## Real-Time Communication Details

### WebSocket:
- **Full-duplex communication**: Messages are exchanged in both directions, allowing both clients and the server to send and receive messages actively.

### Server-Sent Events (SSE):
- **One-way communication**: The server sends messages to the clients in real-time. Clients cannot send data back to the server over SSE but can use other methods like REST APIs for sending data.
