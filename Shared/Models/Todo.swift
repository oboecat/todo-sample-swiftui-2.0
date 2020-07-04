//
//  Todo.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation

struct Todo: Codable, Identifiable {
    var body: String
    var completed: Bool
    var id: String
}

extension Todo {
    static let sampleList = [
        Todo(body: "Buy cat food", completed: false, id: "0"),
        Todo(body: "Water plants", completed: true, id: "1")
    ]
}
