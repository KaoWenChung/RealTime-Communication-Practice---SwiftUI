//
//  NetworkService.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import Foundation

protocol DataTransfer {
    func request(_ request: URLRequest) async throws
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
    func dataTask(with request: URLRequest) -> URLSessionDataTask
}

final class DefaultDataTransfer {
    private let decoder: DecoderType
    private let urlSession: URLSessionType
    init(decoder: DecoderType = JSONDecoder(),
         urlSession: URLSessionType = URLSession.shared) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
}

extension DefaultDataTransfer: DataTransfer {
    func request(_ request: URLRequest) async throws {
        let (_, _) = try await urlSession.data(for: request, delegate: nil)
    }

    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, _) = try await urlSession.data(for: request, delegate: nil)
        let result = try decoder.decode(T.self, from: data)
        return result
    }

    func dataTask(with request: URLRequest) -> URLSessionDataTask {
        urlSession.dataTask(with: request)
    }
}
