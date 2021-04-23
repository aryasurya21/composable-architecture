//
//  TodosTests.swift
//  composable-architectureTests
//
//  Created by arya.surya on 22/04/21.
//

import XCTest
import ComposableArchitecture
@testable import composable_architecture

class TodosTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testCompletingTodo(){
        let store = TestStore(
            initialState: AppState(todos: [
                Todo(id: UUID(), description: "Buy Milk", isComplete: false)
            ]),
            reducer: appReducer,
            environment: AppEnvironment(uuid: {
                fatalError("expected not to be called")
            }, mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        
        store.assert(
            .send(.todo(index: 0, action: .checkBoxTapped)){
                $0.todos[0].isComplete = true
            },
            .do{
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted)
        )
    }
    
    func testAddTodo(){
        let dummyUUID = UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")!
        let store = TestStore(
            initialState: AppState(todos: []),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { dummyUUID },
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        
        store.assert(
            .send(.addButtonTapped){
                $0.todos = [
                    .init(
                        id: dummyUUID,
                        description: "",
                        isComplete: false
                    )
                ]
            }
        )
    }
    
    func testTodoSorting(){
        let store = TestStore(
            initialState: AppState(todos: [
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Buy Milk",
                    isComplete: false
                ),
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Buy Eggs",
                    isComplete: false
                )
            ]),
            reducer: appReducer,
            environment: AppEnvironment(uuid: {
                fatalError("expected not to be called")
            }, mainQueue: scheduler.eraseToAnyScheduler())
        )
        
        store.assert(
            .send(.todo(index: 0, action: .checkBoxTapped)){
                $0.todos[0].isComplete = true
            },
            .do {
//                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted){
                $0.todos.swapAt(0, 1)
            }
        )
    }
    
    func testTodoSortingCancellation(){
        let store = TestStore(
            initialState: AppState(todos: [
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Buy Milk",
                    isComplete: false
                ),
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Buy Eggs",
                    isComplete: false
                )
            ]),
            reducer: appReducer,
            environment: AppEnvironment(uuid: {
                fatalError("expected not to be called")
            }, mainQueue: scheduler.eraseToAnyScheduler())
        )
        
        store.assert(
            .send(.todo(index: 0, action: .checkBoxTapped)){
                $0.todos[0].isComplete = true
            },
            .do {
                self.scheduler.advance(by: 0.5)
            },
            .send(.todo(index: 0, action: .checkBoxTapped)){
                $0.todos[0].isComplete = false
            },
            .do {
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted)
        )
        
    }
}
