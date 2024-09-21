//
//  iOS_RealTime_Communication_PracticeApp.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI

@main
struct iOS_RealTime_Communication_PracticeApp: App {
    var body: some Scene {
        WindowGroup {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval.infinity
            configuration.timeoutIntervalForResource = TimeInterval.infinity
            let sseHandler = SSEHandler()
            let urlsession = URLSession(configuration: configuration, delegate: sseHandler, delegateQueue: .main)
            let contentVM = DefaultContentViewModel(msgService: DefaultMessageSSEService(sseDataTransfer: DefaultDataTransfer(urlSession: urlsession)))

            return ContentView(viewModel: contentVM)
        }
    }
}
