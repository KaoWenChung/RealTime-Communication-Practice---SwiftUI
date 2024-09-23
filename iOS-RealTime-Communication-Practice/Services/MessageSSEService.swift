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

final class DefaultMessageSSEService {
    private let dataTransfer: DataTransfer
    private let sseDataTransfer: DataTransfer
    private var cancellables = Set<AnyCancellable>()
    init(dataTransfer: DataTransfer = DefaultDataTransfer(),
         sseDataTransfer: DataTransfer) {
        self.dataTransfer = dataTransfer
        self.sseDataTransfer = sseDataTransfer
    }
}

extension DefaultMessageSSEService: MessageService {
    func sendMsg(_ message: String) async throws {
        let urlString = APIEndpoints.sendMsg
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["message": message]
        request.httpBody = try? JSONEncoder().encode(body)
        try await dataTransfer.request(request)
    }

    func readMsgs() async throws -> [String] {
        let urlString = APIEndpoints.readMsgs
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        let request = URLRequest(url: url)
        let result: [String] = try await dataTransfer.request(request)
        return result
    }

    func setupConnection() -> AnyPublisher<String, Error> {
        let urlString = APIEndpoints.stream
        guard let url = URL(string: urlString) else {
            return Fail(error: ServiceError.urlGeneration).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.addValue("text/event-stream", forHTTPHeaderField: "Accept")
        let dataTask = sseDataTransfer.dataTask(with: request)
        dataTask.resume()
        return NotificationCenter.default.publisher(for: .newSSEMessage)
            .compactMap { $0.object as? String }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
