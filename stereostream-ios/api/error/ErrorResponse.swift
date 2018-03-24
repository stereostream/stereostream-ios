//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct ErrorResponse: Codable {
    let error: String
    let error_message: String

    // Not part of response from server
    var _meta: String? = nil

    init(error: String, error_message: String) {
        self.error = error
        self.error_message = error_message
        self._meta = nil
    }

    func toString() -> String {
        return "\(error): \(error_message)\(_meta == nil ? "" : " | with " + _meta!)"
    }
}
