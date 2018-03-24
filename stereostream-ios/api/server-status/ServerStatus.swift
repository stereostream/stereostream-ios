//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct ServerStatus: Codable {
    let version: String
    let private_ip: String

    func getString() -> String {
        return "\(version) @ \(private_ip)"
    }
}
