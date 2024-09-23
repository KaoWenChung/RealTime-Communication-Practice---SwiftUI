//
//  SSEHandler.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/23.
//

import Foundation

class SSEHandler: NSObject, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            let lines = message.components(separatedBy: "\n\n")
            for line in lines {
                if line.hasPrefix("data: ") {
                    let eventMessage = line.dropFirst(6)
                    print("SSE Message received: \(eventMessage)")
                    NotificationCenter.default.post(name: .newSSEMessage, object: eventMessage)
                }
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE connection failed with error: \(error)")
        } else {
            print("SSE connection completed")
        }
    }
}
