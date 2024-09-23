//
//  ContentViewModel.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI
import Combine

protocol ContentViewModel {
    var title: String { get }
    var messages: [String] { get }
    func setupEventSource()
    func sendMessage(_ message: String) async
    func readMessages() async
}

@Observable
final class DefaultContentViewModel: ContentViewModel {
    let title: String
    private let msgService: MessageService
    private var cancellables = Set<AnyCancellable>()
    private(set) var messages: [String] = []

    init(title: String = "",
         msgService: MessageService) {
        self.title = title
        self.msgService = msgService
    }

    func setupEventSource() {
        msgService.setupConnection()
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
