//
//  CategoryView.swift
//  iOS-RealTime-Communication-Practice
//
//  Created by wyn on 2024/9/23.
//

import SwiftUI

import SwiftUI

struct CategoryView: View {
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Communication Type")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(
                    destination: container.makeSSEView()
                ) {
                    Text("SSE (Server-Sent Events)")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                NavigationLink(
                    destination: container.makeWebSocketView()
                ) {
                    Text("WebSocket")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
        }
    }
}
