//
//  APIEndpoints.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

enum APIEndpoints {
    private static let baseURLString = "http://127.0.0.1:5000/"
    static let stream = baseURLString + "stream"
    static let readMsgs = baseURLString + "messages"
    static let sendMsg = baseURLString + "send"
    static let websocket = "ws://localhost:5001"
}
