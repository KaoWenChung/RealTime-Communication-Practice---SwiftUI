//
//  APIEndpoints.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import Foundation

enum APIEndpoints {
    private static let baseURLString = "http://127.0.0.1:5000/"

    static func websocket() -> URL {
        guard let url = URL(string: "ws://localhost:5001") else { fatalError("Invalid URL")}
        return url
    }

    static func stream() -> URLRequest {
        let urlString = baseURLString + "stream"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.addValue("text/event-stream", forHTTPHeaderField: "Accept")
        return request
    }

    static func readMsgs() -> URLRequest {
        let urlString = baseURLString + "messages"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        return URLRequest(url: url)
    }

    static func sendMsg(_ message: String) -> URLRequest {
        let urlString = baseURLString + "send"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["message": message]
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
}
