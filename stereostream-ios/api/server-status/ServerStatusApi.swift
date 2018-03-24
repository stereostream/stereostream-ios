//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

class ServerStatusApi: ApiBase {
    let api = "/api"

    func get(completion: @escaping (ErrorResponse?, ServerStatus?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .get(path: api, completion: completion)
    }
}
