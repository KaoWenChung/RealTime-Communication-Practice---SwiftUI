//
//  MessageSSEService.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import Foundation
import Combine

enum ServiceError: Error {
    case urlGeneration
}

protocol MessageSSEService {
    func sendMsg(_ message: String) async throws
    func readMsgs() async throws -> [String]
    func setupEventSource() -> AnyPublisher<String, Error>
}

final class DefaultMessageSSEService {
    private let dataTransfer: DataTransfer
    private let sseHandler = SSEHandler()
    private var cancellables = Set<AnyCancellable>()
    init(dataTransfer: DataTransfer = DefaultDataTransfer()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval.infinity
        configuration.timeoutIntervalForResource = TimeInterval.infinity
        URLSession(configuration: configuration, delegate: sseHandler, delegateQueue: .main)
        self.dataTransfer = dataTransfer
    }
}

extension DefaultMessageSSEService: MessageSSEService {
    func sendMsg(_ message: String) async throws {
        let urlString = APIEndpoints.sendMsg
        guard let url = URL(string: urlString) else { throw ServiceError.urlGeneration }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["message": message]
        request.httpBody = try? JSONEncoder().encode(body)
        try await dataTransfer.request(request)
    }

    func readMsgs() async throws -> [String] {
        let urlString = APIEndpoints.readMsgs
        guard let url = URL(string: urlString) else { throw ServiceError.urlGeneration }
        let request = URLRequest(url: url)
        let result: [String] = try await dataTransfer.request(request)
        return result
    }

    func setupEventSource() -> AnyPublisher<String, Error> {
        let urlString = APIEndpoints.stream
        guard let url = URL(string: urlString) else {
            return Fail(error: ServiceError.urlGeneration).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("text/event-stream", forHTTPHeaderField: "Accept")

        sseHandler.onMessageReceived = { message in
            // Broadcast the message
            print("SSE Message received: \(message)")
            NotificationCenter.default.post(name: .newSSEMessage, object: message)
        }

        // Create the data task to handle SSE
        let dataTask = dataTransfer.dataTask(with: request)
        dataTask.resume()

        // Use Combine to receive the messages posted via NotificationCenter
        return NotificationCenter.default.publisher(for: .newSSEMessage)
            .compactMap { $0.object as? String }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class SSEHandler: NSObject, URLSessionDataDelegate {
    var onMessageReceived: ((String) -> Void)?

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            // Process the incoming data as a string
            let lines = message.components(separatedBy: "\n\n")
            for line in lines {
                if line.hasPrefix("data: ") {
                    let eventMessage = line.dropFirst(6)
                    onMessageReceived?(String(eventMessage))
                }
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE connection failed with error: \(error)")
        } else {
            print("SSE connection completed")
        }
    }
}
