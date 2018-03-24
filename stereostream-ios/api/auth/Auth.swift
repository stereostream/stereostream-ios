//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct Auth: Codable {
    let email: String
    let password: String

    func toJSON() -> Data? {
        return try? JSONSerialization.data(
                withJSONObject: self, options: []
        )
    }
}
