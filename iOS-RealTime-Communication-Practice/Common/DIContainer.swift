//
//  DIContainer.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/23.
//

import Foundation

final class DIContainer {
    func makeSSEView() -> ContentView {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval.infinity
        configuration.timeoutIntervalForResource = TimeInterval.infinity
        let sseHandler = SSEHandler()
        let urlsession = URLSession(configuration: configuration, delegate: sseHandler, delegateQueue: .main)
        let contentVM = DefaultContentViewModel(title: "SSE (Server-Sent Events)",
                                                msgService: DefaultMessageSSEService(sseDataTransfer: DefaultDataTransfer(urlSession: urlsession)))

        return ContentView(viewModel: contentVM)
    }

    func makeWebSocketView() -> ContentView {
        let contentVM = DefaultContentViewModel(title: "WebSocket",
                                                msgService: DefaultMessageWebSocketService())

        return ContentView(viewModel: contentVM)
    }
}
