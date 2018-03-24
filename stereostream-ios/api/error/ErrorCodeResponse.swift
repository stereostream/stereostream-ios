//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

struct ErrorCodeResponse: Codable {
    let code: String
    let message: String

    func toErrorResponse() -> ErrorResponse {
        let _code = "\(code): "
        return ErrorResponse(error: code,
                             error_message: message.starts(with: _code) ?
                                String(message.suffix(from: message.index(message.startIndex, offsetBy: _code.count)))
                                : message)
    }
}

