//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

class ApiBase {
    public var baseUrl: String?

    convenience init(baseUrl: String?) {
        self.init()
        if let baseUrl = baseUrl {
            self.baseUrl = baseUrl
        }
    }

    init() {
        self.baseUrl = Settings.hostname
    }
}
