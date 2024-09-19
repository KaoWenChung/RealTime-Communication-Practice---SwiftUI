//
//  ContentViewModel.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI

protocol ContentViewModel {
    var messages: [String] { get }
    func setupEventSource()
    func sendMessage(_ message: String)
}

@Observable
final class DefaultContentViewModel: ContentViewModel {
    private(set) var messages: [String] = []
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
    func sendMessage(_ message: String) {
        let url = URL(string: "http://127.0.0.1:5000/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["message": message]
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { _, _, _ in
        }.resume()
    }
}
