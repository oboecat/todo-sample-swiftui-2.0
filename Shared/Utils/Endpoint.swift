//
//  Endpoint.swift
//  NewTodoSample
//
//  Created by Lila Pustovoyt on 6/29/20.
//

import Foundation
import Combine
import Auth0

struct Endpoint<ResponseType> where ResponseType: Decodable {
    typealias Headers = [String: String]
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    let method: Method
    let url: URL
    var headers: Headers
    let body: Data?
    
    private var request: URLRequest {
        get {
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            req.allHTTPHeaderFields = headers
            req.httpBody = body
            
            return req
        }
    }
    
    init(method: Method, url: URL, headers: Headers = Headers(), body: Data? = nil) {
        var headers = headers
        headers["Accepts"] = "application/json"
        
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
    
    init<T>(method: Method, url: URL, headers: Headers = Headers(), encodableBody body: T) where T: Encodable {
        var headers = headers
        headers["Content-Type"] = "application/json"
        
        let bodyJSON = try! JSONEncoder().encode(body)
        
        self.init(method: method, url: url, headers: headers, body: bodyJSON)
    }
    
    func withAuth(token: String) -> Endpoint<ResponseType> {
        var endpointWithAuth = self
        endpointWithAuth.headers["Authorization"] = "Bearer \(token)"
        
        return endpointWithAuth
    }
    
    func fetch() -> AnyPublisher<ResponseType, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
