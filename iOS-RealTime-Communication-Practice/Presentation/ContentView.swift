//
//  ContentView.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/19.
//

import SwiftUI

struct ContentView: View {
    @State private var messageText = ""
    @State private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel = DefaultContentViewModel()) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack {
            List(viewModel.messages, id: \.self) { message in
                Text(message)
            }
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage(messageText)
                    messageText.removeAll()
                }
            }
            .padding()
        }
        .onAppear(perform: viewModel.setupEventSource)
    }
}


//#Preview {
//    ContentView()
//}
