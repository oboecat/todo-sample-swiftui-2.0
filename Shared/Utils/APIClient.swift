//
//  APIClient.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import Combine
import Auth0

struct APIClient {
    typealias Headers = [String: String]
    
    let base = URL(string: "http://lilas-macbook-pro.local:3000/")!
    var auth0Helper: Auth0Helper
    
    func getTodos() -> AnyPublisher<[Todo], Error> {
        fetchWithAuth { headers in
            Endpoint<[Todo]>(
                method: .get,
                url: self.base,
                headers: headers
            )
        }
    }
    
    func addNewTodo(_ todo: Todo) -> AnyPublisher<Todo, Error> {
        fetchWithAuth { headers in
            Endpoint<Todo>(
                method: .post,
                url: self.base,
                headers: headers,
                encodableBody: todo
            )
        }
    }
    
    func updateTodo(_ todo: Todo) -> AnyPublisher<Todo, Error> {
        fetchWithAuth { headers in
            Endpoint<Todo>(
                method: .patch,
                url: self.base.appendingPathComponent("\(todo.id)"),
                headers: headers,
                encodableBody: todo
            )
        }
    }
    
    func deleteTodo(_ todo: Todo) -> AnyPublisher<Todo, Error> {
        fetchWithAuth { headers in
            Endpoint<Todo>(
                method: .delete,
                url: self.base.appendingPathComponent("\(todo.id)"),
                headers: headers
            )
        }
    }
    
    
    private func fetchWithAuth<T>(endpoint: @escaping (Headers) -> Endpoint<T>) -> AnyPublisher<T, Error> {
        auth0Helper.credentials()
            .map { credentials in
                ["Authorization": "Bearer \(credentials.accessToken!)"]
            }
            .map { headers in
                endpoint(headers)
            }
            .flatMap { $0.fetch() }
            .eraseToAnyPublisher()
    }
}
