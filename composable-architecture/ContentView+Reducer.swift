//
//  ContentView+Reducer.swift
//  composable-architecture
//
//  Created by arya.surya on 23/04/21.
//

import Foundation
import ComposableArchitecture
import Combine

struct AppState: Equatable {
    var todos: [Todo]
}

enum AppAction: Equatable {
    case todo(index: Int, action: TodoAction)
    case addButtonTapped
    case todoDelayCompleted
}

struct AppEnvironment {
    var uuid: () -> UUID
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

internal let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
    Reducer.combine(
        todoReducer.forEach(
            state: \AppState.todos,
            action: /AppAction.todo(index:action:),
            environment: { (_) in TodoEnvironment() }
        ),
        Reducer { state, action, env in
            switch action {
          
            case .addButtonTapped:
                state.todos.insert(Todo(id: env.uuid()), at: 0)
                return .none
                
            case .todo(index: _, action: .checkBoxTapped):
                struct CancelDelayId: Hashable {}
                
                return Effect(value: AppAction.todoDelayCompleted)
                    .debounce(
                        id: CancelDelayId(),
                        for: 1,
                        scheduler: env.mainQueue
                    )

            case .todo(index: let index, action: let action):
                return .none
                
            case .todoDelayCompleted:
                state.todos = state.todos
                    .enumerated()
                    .sorted { lhs, rhs in
                        (!lhs.element.isComplete && rhs.element.isComplete)
                            || lhs.offset < rhs.offset
                    }
                    .map(\.element)
                return .none
            }
        }
    ).debug()


