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
    func setupEventSource() throws -> AnyPublisher<String, Error>
}

final class DefaultMessageSSEService {
    private let dataTransfer: DataTransfer
    private var cancellables = Set<AnyCancellable>()
    init(dataTransfer: DataTransfer = DefaultDataTransfer()) {
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

    func setupEventSource() throws -> AnyPublisher<String, Error> {
        let urlString = APIEndpoints.stream
        guard let url = URL(string: urlString) else { throw ServiceError.urlGeneration }
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval.infinity
        request.addValue("text/event-stream", forHTTPHeaderField: "Accept")
        
        return dataTransfer.dataTaskPublisher(request)
            .tryMap { result -> String in
                let dataString = String(decoding: result.data, as: UTF8.self)
                print(dataString)
                return dataString
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
