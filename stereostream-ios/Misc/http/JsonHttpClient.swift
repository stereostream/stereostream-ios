//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

class JsonHttpClient: HttpClient {
    static var _JsonHttpClient: JsonHttpClient = JsonHttpClient()

    static func instance(root: String?) -> JsonHttpClient {
        if root != nil && _JsonHttpClient.root != root {
            _JsonHttpClient = JsonHttpClient(root: root)
        }
        return _JsonHttpClient
    }

    override class func instance() -> JsonHttpClient {
        if _JsonHttpClient.root != "" {
            _JsonHttpClient = JsonHttpClient()
        }
        return _JsonHttpClient
    }

    func get<T: Decodable>(path: String, completion: @escaping (ErrorResponse?, T?) -> ()) {
        request(path: path, mimeType: mimeTypes["json"]!, method: .get, data: nil, completion: completion)
    }

    func post<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        request(path: path, mimeType: mimeTypes["json"]!, method: .post, data: data, completion: completion)
    }

    func put<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        request(path: path, mimeType: mimeTypes["json"]!, method: .put, data: data, completion: completion)
    }

    func delete<T: Decodable>(path: String, data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        request(path: path, mimeType: mimeTypes["json"]!, method: .delete, data: data, completion: completion)
    }
}
