//
//  TodoView+Reducer.swift
//  composable-architecture
//
//  Created by arya.surya on 23/04/21.
//

import Foundation
import ComposableArchitecture

struct Todo: Equatable, Identifiable {
    let id: UUID
    var description: String = ""
    var isComplete: Bool = false
}

enum TodoAction: Equatable {
    case checkBoxTapped
    case textFieldChanged(String)
}

struct TodoEnvironment {
    
}

internal let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, env in
    switch action {
    case .checkBoxTapped:
        state.isComplete.toggle()
        return .none
        
    case .textFieldChanged(let text):
        state.description = text
        return .none
    }
}
