//
//  ContentViewModel.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI
import Combine

protocol ContentViewModel {
    var messages: [String] { get }
    func setupEventSource()
    func sendMessage(_ message: String) async
    func readMessages() async
}

@Observable
final class DefaultContentViewModel: ContentViewModel {
    private let msgService: MessageSSEService
    private var cancellables = Set<AnyCancellable>()
    private(set) var messages: [String] = []

    init(msgService: MessageSSEService) {
        self.msgService = msgService
    }

    func setupEventSource() {
        msgService.setupEventSource()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("SSE stream finished")
                case .failure(let error):
                    print("Error receiving SSE:", error)
                }
            }, receiveValue: { [weak self] newMessage in
                self?.messages.append(newMessage)
            })
            .store(in: &cancellables)
    }

    func readMessages() async {
        do {
            let allMsgs = try await msgService.readMsgs()
            messages = allMsgs
        } catch {
            print("something wrong:", error)
        }
    }

    func sendMessage(_ message: String) async {
        do {
            try await msgService.sendMsg(message)
        } catch {
            print("something wrong:", error)
        }
    }
}
