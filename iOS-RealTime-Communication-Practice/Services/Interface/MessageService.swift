//
//  MessageService.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/23.
//

import Combine

protocol MessageService {
    func sendMsg(_ message: String) async throws
    func readMsgs() async throws -> [String]
    func setupConnection() -> AnyPublisher<String, Error>
}
