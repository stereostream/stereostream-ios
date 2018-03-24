//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation

protocol Loopable {
    var allProperties: [String: Any] { get }
}

extension Loopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }
}
