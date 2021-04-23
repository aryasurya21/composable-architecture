//
//  ContentView.swift
//  composable-architecture
//
//  Created by arya.surya on 21/04/21.
//

import SwiftUI
import ComposableArchitecture

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
                environment: AppEnvironment(
                    uuid: UUID.init,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
