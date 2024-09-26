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
        let request = APIEndpoints.sendMsg(message)
        try await dataTransfer.request(request)
    }

    func readMsgs() async throws -> [String] {
        let request = APIEndpoints.readMsgs()
        let result: [String] = try await dataTransfer.request(request)
        return result
    }

    func setupConnection() -> AnyPublisher<String, Error> {
        let request = APIEndpoints.stream()
        let dataTask = sseDataTransfer.dataTask(with: request)
        dataTask.resume()
        // SSEHander will then be able to listen the message then post
        return NotificationCenter.default.publisher(for: .newSSEMessage)
            .compactMap { $0.object as? String }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
