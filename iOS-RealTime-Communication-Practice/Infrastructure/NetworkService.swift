//
//  NetworkService.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import Foundation

enum NetworkError {
    case urlGeneration
}

protocol NetworkService {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class DefaultNetworkService {
    private let decoder: DecoderType
    private let urlSession: URLSessionType
    init(decoder: DecoderType = JSONDecoder(),
         urlSession: URLSessionType = URLSession.shared) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
}

extension DefaultNetworkService: NetworkService {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, _) = try await urlSession.data(for: request, delegate: nil)
        let result = try decoder.decode(T.self, from: data)
        return result
    }
}
