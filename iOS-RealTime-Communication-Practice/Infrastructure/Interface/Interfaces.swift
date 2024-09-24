//
//  Interfaces.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import Foundation

protocol URLSessionType {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func dataTask(with request: URLRequest) -> URLSessionDataTask
}

protocol DecoderType {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension URLSession: URLSessionType {}
extension JSONDecoder: DecoderType {}

protocol WebSocketURLSession {
    func webSocketTask(with url: URL) -> URLSessionWebSocketTask
}

protocol WebSocketTaskType {
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, any Error>) -> Void)
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    func receive() async throws -> URLSessionWebSocketTask.Message
    func resume()
}

extension URLSessionWebSocketTask: WebSocketTaskType {}
extension URLSession: WebSocketURLSession {}
