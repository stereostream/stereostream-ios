//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import UIKit

fileprivate struct DateMessage {
    let datetime: Date
    let message: String
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }

    @objc func newViewWillAppear(_ animated: Bool) {
        self.newViewWillAppear(animated)
        Settings.loadCache()
        if let kw = UIApplication.shared.keyWindow {
            if let rv = kw.rootViewController {
                if rv.restorationIdentifier != "AuthNavigator" && String(describing: type(of: self)) != "UIAlertController" {
                    redirIfUnAuth()
                }
            }
        }
    }

    static func swizzleViewWillAppear() {
        if self != UIViewController.self {
            return
        }
        let _: () = {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.newViewWillAppear(_:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }

    @objc func newViewWillDisappear(_ animated: Bool) {
        self.newViewWillDisappear(animated)
        Settings.saveCache()
    }

    static func swizzleViewWillDisappear() {
        if self != UIViewController.self {
            return
        }
        let _: () = {
            let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
            let swizzledSelector = #selector(UIViewController.newViewWillDisappear(_:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }()
    }

    // TODO: Don't show multiple alerts in a row
    fileprivate static var lastLogMessageTime: DateMessage?

    class func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController!
    }

    class func mainErr(error: ErrorResponse) {
        let logMessageTime = DateMessage(datetime: Date.init(), message: error.error_message)

        /*if lastLogMessageTime != nil && abs(lastLogMessageTime!.datetime.timeIntervalSince(logMessageTime.datetime)) > 10 {
            return
        }*/

        lastLogMessageTime = logMessageTime

        let alert = UIAlertController(
                title: error.error, message: error.error_message, preferredStyle: .alert
        )
        alert.addAction(
                UIAlertAction(title: NSLocalizedString("OK", comment: "Error"), style: .`default`,
                        handler: { _ in NSLog(error.toString()) })
        )
        DispatchQueue.main.async {
            topMostController().present(alert, animated: true, completion: nil)
        }
    }

    func redirIfUnAuth() {
        if Settings.access_token != nil {
            return
        }

        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }
}
