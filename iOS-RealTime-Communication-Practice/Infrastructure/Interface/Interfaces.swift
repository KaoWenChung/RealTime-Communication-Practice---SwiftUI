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
