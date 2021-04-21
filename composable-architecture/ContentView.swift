//
//  ContentView.swift
//  composable-architecture
//
//  Created by arya.surya on 21/04/21.
//

import SwiftUI
import ComposableArchitecture

struct Todo: Equatable, Identifiable {
    let id: UUID
    var description: String = ""
    var isComplete: Bool = false
}

struct AppState: Equatable {
    var todos: [Todo]
}

enum AppAction {
    case todoCheckBoxTapped(index: Int)
    case todoTextFieldChanged(index: Int, text: String)
}

struct AppEnvironment {
    
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
    case .todoCheckBoxTapped(index: let index):
        state.todos[index].isComplete.toggle()
        return .none
        
    case .todoTextFieldChanged(index: let index, text: let text):
        state.todos[index].description = text
        return .none
    }
}.debug()

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore (self.store) { viewStore in
                List {
                    ForEach(Array(viewStore.todos.enumerated()), id: \.element.id){ idx, todo in
                        HStack {
                            Button(action: {
                                viewStore.send(.todoCheckBoxTapped(index: idx))
                            }, label: {
                                Image(systemName: "checkmark.square")
                            }).buttonStyle(PlainButtonStyle())
                            TextField(
                                "Untitled Todo",
                                text: viewStore.binding(
                                    get: { $0.todos[idx].description },
                                    send: { .todoTextFieldChanged(index: idx, text: $0) }
                                )
                            )
                        }.foregroundColor(todo.isComplete ? .gray : nil)
                    }
                }
            }.navigationBarTitle("Todos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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
