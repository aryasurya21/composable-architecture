//
//  composable_architectureApp.swift
//  composable-architecture
//
//  Created by arya.surya on 21/04/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct composable_architectureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(todos: [
                        Todo(id: UUID(), description: "Buy Milk", isComplete: false),
                        Todo(id: UUID(), description: "Buy Eggs", isComplete: false),
                        Todo(id: UUID(), description: "Cook Dinner", isComplete: false)
                    ]),
                    reducer: appReducer,
                    environment: AppEnvironment()
                )
            )
        }
    }
}
