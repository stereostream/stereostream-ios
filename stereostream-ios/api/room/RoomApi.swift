//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

class RoomApi: ApiBase, Instance {
    static var _instance: RoomApi = RoomApi()

    static func instance() -> RoomApi {
        if _instance.baseUrl == nil || _instance.baseUrl == "" {
            _instance = RoomApi()
        }
        return _instance
    }

    let api = "/api/room";

    func create(room: Room, completion: @escaping (ErrorResponse?, Room?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .post(path: "\(api)/\(room.name)", data: try? JSONEncoder().encode(room),
                        completion: { (error: ErrorResponse?, room: Room?) in
                            if let error = error {
                                return completion(error, nil)
                            } else if let room = room {
                                return completion(error, room)
                            }
                            // TODO: Route to newly created Room
                            return completion(ErrorResponse(error: "NotFound", error_message: "Room"), nil)
                        })
    }

    func read(room: Room, completion: @escaping (ErrorResponse?, Room?) -> ()) {
        JsonHttpClient
                .instance(root: baseUrl)
                .get(path: "\(api)/\(room.name)", completion: { (error: ErrorResponse?, room: Room?) in
                    if let error = error {
                        return completion(error, nil)
                    } else if let room = room {
                        return completion(error, room)
                    }
                    return completion(ErrorResponse(error: "NotFound", error_message: "Room"), nil)
                })
    }
}
