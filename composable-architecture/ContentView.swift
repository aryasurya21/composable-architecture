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

enum TodoAction {
    case checkBoxTapped
    case textFieldChanged(String)
}

struct TodoEnvironment {
    
}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, env in
    switch action {
    case .checkBoxTapped:
        state.isComplete.toggle()
        return .none
        
    case .textFieldChanged(let text):
        state.description = text
        return .none
    }
}

enum AppAction {
    case todo(index: Int, action: TodoAction)
    case addButtonTapped
}

struct AppEnvironment {
    
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
    Reducer.combine(
        todoReducer.forEach(
            state: \AppState.todos,
            action: /AppAction.todo(index:action:),
            environment: { (_) in TodoEnvironment() }
        ),
        Reducer { state, action, environment in
            switch action {
            case .todo(index: let index, action: let action):
                return .none
            case .addButtonTapped:
                state.todos.insert(Todo(id: UUID()), at: 0)
                return .none
            }
        }
    ).debug()


struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore (self.store) { viewStore in
                List {
                    ForEachStore(self.store.scope(
                        state: \.todos,
                        action: AppAction.todo(index:action:)),
                        content: TodoView.init(todoStore:)
                    )
                }.navigationBarTitle("Todos")
                .navigationBarItems(trailing: Button("Add", action: {
                    viewStore.send(.addButtonTapped)
                }))
            }
        }
    }
}

struct TodoView: View {
    internal let todoStore: Store<Todo, TodoAction>
    
    var body: some View {
        WithViewStore (todoStore) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkBoxTapped) }) {
                    Image(systemName:  viewStore.isComplete ? "checkmark.square" : "square")
                }.buttonStyle(PlainButtonStyle())
                
                TextField(
                    "Untitled Todo",
                    text: viewStore.binding(
                        get: \.description,
                        send: TodoAction.textFieldChanged
                    )
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
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
