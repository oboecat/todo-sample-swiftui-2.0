//
//  ErrorLog.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 7/20/20.
//

import Foundation

struct ErrorLog: Identifiable {
    var error: Error
    var id = UUID()
}
