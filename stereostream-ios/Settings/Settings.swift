//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import Foundation
import os.log

/*
 Bug report:
    There was a bug with saving variables to UserDefaults.
    This occurred when reoppening the app.
        There was a request made to load data from UserDefaults, the timing of this request was
        not timed well. It resulted in an out-of-sync data request because the data was saved before it was finshed being retrieved. Thus resulting in re-inserting nil values into UserDefaults.
 
 tldr: Saved nil data before loading real data.
 
 Temp solution: Call saveCache when import data is fetched.
 
 Alternative solution: Swizzle on viewDidAppear (we would like to load data so we can make assumptions throughout the project that data is always upto date) viewWillAppear (we would like to save data here)
 */
class Settings: Loopable {
    public static var hostname: String?
    public static var current_user: String?
    public static var access_token: String?

    static func saveCache() {
        let defaults = UserDefaults.standard
        defaults.setValue(Settings.hostname, forKey: "hostname")
        defaults.setValue(Settings.current_user ?? "empty", forKey: "currentuser")
        defaults.setValue(Settings.access_token, forKey: "accesstoken")
    }

    static func loadCache() {
        let defaults = UserDefaults.standard
        Settings.hostname = defaults.string(forKey: "hostname")
        Settings.current_user = defaults.string(forKey: "currentuser")
        Settings.access_token = defaults.string(forKey: "accesstoken")
    }
    
    static func toString() -> String {
        return "Settings(hostname: \(String(describing: Settings.hostname)), access_token: \(String(describing: Settings.access_token)), currentuser: \(String(describing: Settings.current_user)))"
    }
}
