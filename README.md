# Real-Time Message System

## Overview
This project implements a real-time messaging system using Flask and Server-Sent Events (SSE). It includes a simple HTML client that allows users to send messages to a server, which then broadcasts these messages to all connected clients in real-time.

## Features
- **Send Message**: Users can send messages through a simple web interface.
- **Real-Time Updates**: All connected clients receive message updates in real-time using SSE.

## Tech Stack
- **Backend**: Flask (Python)
- **iOS app**: SwiftUI, Swift
- **Frontend**: HTML, JavaScript
- **Communication**: Server-Sent Events (SSE)

## Project Structure
- `app.py`: The Flask application.
- `templates/`
  - `index.html`: The HTML file for the frontend interface.

## Setup and Installation

### Prerequisites
- Python 3.6 or higher
- Flask

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/real-time-message-system.git
   cd real-time-message-system
   ```

2. Set up a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. Install the requirements:
   ```bash
   pip install flask
   ```

4. Run the application:
   ```bash
   python app.py
   ```

### Accessing the Application
Open your web browser and navigate to `http://127.0.0.1:5000/` to see the application in action.

## Usage
- **Sending a Message**: Enter a message in the text field and click the "Send Message" button. The message will appear in the table below the text field.
- **Viewing Messages**: All messages sent by any user will appear in real-time in the message table.
