////  
//  Created by Samuel Marks.
//  Copyright © 2018. Apache License 2.0.
//  

protocol Instance {
    associatedtype T
    // static var _instance: T {get set}
    static func instance() -> T
}
