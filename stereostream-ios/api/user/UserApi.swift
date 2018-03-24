//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

class UserApi: ApiBase {
    let api = "/api/user";

    func register(user: Auth, completion: @escaping (ErrorResponse?, User?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .post(path: api, data: try? JSONEncoder().encode(user),
                        completion: { (error: ErrorResponse?, user: User?) in
                            if (error != nil) {
                                return completion(error, nil)
                            } else if (user == nil) {
                                return completion(ErrorResponse(error: "NotFound", error_message: "User"), nil)
                            }

                            if let user = user {
                                Settings.access_token = user.access_token
                                Settings.current_user = user.email
                                return completion(error, user)
                            }
                        })
    }
}
