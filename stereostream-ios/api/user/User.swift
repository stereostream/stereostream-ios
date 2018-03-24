//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct User: Codable {
    let access_token: String
    let email: String
    let roles: [String]
}
