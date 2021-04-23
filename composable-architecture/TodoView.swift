//
//  TodoView.swift
//  composable-architecture
//
//  Created by arya.surya on 23/04/21.
//

import SwiftUI
import ComposableArchitecture

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

struct TodoView_Previews: PreviewProvider {
    
    static var previews: some View {
        TodoView(
            todoStore: .init(
                initialState: Todo(
                    id: .init()
                ),
                reducer: todoReducer,
                environment: TodoEnvironment()
            )
        )
    }
}
