//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

// See RFC7231 and RFC5789 for more info
enum HttpMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}

class HttpClient: Instance {
    static var _instance: HttpClient = HttpClient()

    open class func instance() -> HttpClient {
        if _instance.root == "" {
            _instance = HttpClient()
        }
        return _instance
    }

    var root: String

    init(root path: String?) {
        Settings.loadCache()
        if let path = path {
            self.root = path
        } else {
            self.root = ""
        }
    }

    convenience init() {
        self.init(root: nil)
    }

    func _toApiPath(_ path: String) -> String {
        return path.starts(with: "http") ? path : "\(root)\(path.starts(with: "/") ? path : "/" + path)"
    }

    func request<T: Decodable>(path: String, mimeType: String, method: HttpMethod,
                               data: Data?, completion: @escaping (ErrorResponse?, T?) -> ()) {
        guard let url = URL(string: _toApiPath(path)) else {
            return completion(ErrorResponse(error: "URL", error_message: "Cannot create URL from \(path)"), nil)
        }
        var request = URLRequest(url: url)
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        if Settings.access_token != nil {
            request.setValue(Settings.access_token!, forHTTPHeaderField: "X-Access-Token")
        }
        request.httpMethod = method.rawValue
        if data != nil && method != .get {
            request.httpBody = data!
        }

        let session = URLSession.shared

        let er = "error calling \(request.httpMethod!) on \(url.absoluteURL)"

        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                return completion(ErrorResponse(error: "dataTask", error_message: "\(er)\n\(error!.localizedDescription)"), nil)
            }
            guard let responseData = data else {
                return completion(
                        ErrorResponse(error: "responseData", error_message: "\(er)\nError: did not receive data"), nil)
            }

            do {
                return completion(nil, try JSONDecoder().decode(T.self, from: responseData))
            } catch {
                do {
                    var e: ErrorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                    e._meta = er
                    return completion(e, nil)
                } catch {

                    do {
                        var e: ErrorResponse = try JSONDecoder()
                                .decode(ErrorCodeResponse.self, from: responseData)
                                .toErrorResponse()
                        e._meta = er
                        return completion(e, nil)
                    } catch {
                        return completion(ErrorResponse(error: "JSONDecoder",
                                error_message: "failed on \(request.httpMethod!) \(url.absoluteURL)." +
                                        " Str: \(String(describing: String(data: responseData, encoding: String.Encoding.utf8)))"), nil)
                    }
                }
            }
        }
        task.resume()
    }
}
