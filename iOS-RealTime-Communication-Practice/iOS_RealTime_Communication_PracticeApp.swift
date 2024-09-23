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
            let diContainer = DIContainer()
            CategoryView(container: diContainer)
        }
    }
}
