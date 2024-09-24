//
//  MessageWebSocketService.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/23.
//

import Combine
import Foundation

final class DefaultMessageWebSocketService {
    private let dataTransfer: DataTransfer
    private let webSocketTask: WebSocketTaskType
    private var cancellables = Set<AnyCancellable>()
    
    init(dataTransfer: DataTransfer = DefaultDataTransfer(),
         urlSession: WebSocketURLSession = URLSession(configuration: .default)) {
        self.dataTransfer = dataTransfer
        guard let url = URL(string: APIEndpoints.websocket) else { fatalError("Invalid URL") }
        self.webSocketTask = urlSession.webSocketTask(with: url)
    }

    private func receiveMessage(_ subject: PassthroughSubject<String, Error>) {
        webSocketTask.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    subject.send(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        subject.send(text)
                    }
                default:
                    break
                }
                self?.receiveMessage(subject)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }
    }
}

extension DefaultMessageWebSocketService: MessageService {
    func sendMsg(_ message: String) async throws {
        let message = URLSessionWebSocketTask.Message.string(message)
        try await webSocketTask.send(message)
    }

    func readMsgs() async throws -> [String] {
        return []
    }

    func setupConnection() -> AnyPublisher<String, Error> {
        webSocketTask.resume()
        let subject = PassthroughSubject<String, Error>()
        receiveMessage(subject)

        return subject.eraseToAnyPublisher()
    }
}
