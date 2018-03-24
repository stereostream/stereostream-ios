//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct Room: Codable {
    let name: String
    let owner: String

    func toString() -> String {
        return "\(name) by \(owner)"
    }
}
