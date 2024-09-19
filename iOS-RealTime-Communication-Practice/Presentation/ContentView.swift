//
//  ContentView.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI

struct ContentView: View {
    @State private var messages = [String]()
    @State private var messageText = ""

    var body: some View {
        VStack {
            List(messages, id: \.self) { message in
                Text(message)
            }
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
        .onAppear(perform: setupEventSource)
    }

    func sendMessage() {
        let url = URL(string: "http://127.0.0.1:5000/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["message": messageText]
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.messageText = ""
            }
        }.resume()
    }

    func setupEventSource() {
        let url = URL(string: "http://127.0.0.1:5000/stream")!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval.infinity
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.messages.append(string.replacingOccurrences(of: "data: ", with: ""))
                }
            }
        }
        task.resume()
    }
}


//#Preview {
//    ContentView()
//}
