//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

class RoomsApi: ApiBase {

    static func instance() {
        return
    }

    let api = "/api/room";

    func read(completion: @escaping (ErrorResponse?, Rooms?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .get(path: api,
                        completion: { (error: ErrorResponse?, rooms: Rooms?) in
                            if let error = error {
                                return completion(error, nil)
                            } else if let rooms = rooms {
                                return completion(error, rooms)
                            }
                            return completion(ErrorResponse(error: "NotFound", error_message: "Room"), nil)
                        })
    }
}
