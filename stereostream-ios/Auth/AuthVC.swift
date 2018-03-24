//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import UIKit

class AuthVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInUpBtn: UIButton!
    @IBOutlet weak var serverStatusStackView: UIStackView!
    @IBOutlet weak var apiUrl: UILabel!
    @IBOutlet weak var apiVersion: UILabel!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    @IBAction func emailEdited(_ sender: UITextField) {
        password.isEnabled = true
    }

    @IBAction func emailPrimaryAction(_ sender: UITextField) {
        password.becomeFirstResponder()
    }

    @IBAction func passwordEdited(_ sender: UITextField) {
        signInUpBtn.isEnabled = true
    }

    @IBAction func passwordPrimaryAction(_ sender: UITextField) {
        signInUpBtn.sendActions(for: .touchUpInside)
    }

    @IBAction func onSignInUpClicked(_ sender: UIButton) {
        let auth = Auth.init(email: email.text!, password: password.text!)

        let completion = { (e: ErrorResponse?, u: User?) in
            if let e = e {
                UIViewController.mainErr(error: e)
            } else if u != nil {
                self.redirIfAuth()
            }
        }

        AuthApi().login(auth: auth) { (error: ErrorResponse?, user: User?) in
            if error?.error == "NotFoundError" {
                UserApi().register(user: auth, completion: completion)
            } else {
                completion(error, user)
            }
        }
    }

    
    func initSettings() {
        Settings.loadCache()
        apiUrl.text = Settings.hostname
        ServerStatusApi().get { (error: ErrorResponse?, serverStatus: ServerStatus?) in
            if let error = error {
                UIViewController.mainErr(error: error)
            } else if let serverStatus = serverStatus {
                DispatchQueue.main.async {
                    self.apiVersion.text = serverStatus.getString()
                }
            }
        }
    }

    fileprivate func redirIfAuth() {
        if Settings.access_token == nil {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let window = appDelegate.window {
                DispatchQueue.main.async {
                    window.rootViewController = vc
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            serverStatusStackView.frame.origin.y = keyboardSize.height * 2 - serverStatusStackView.frame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            serverStatusStackView.frame.origin.y += keyboardSize.height
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSettings()
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            return ident == "settingsSegue" || Settings.access_token != nil
        }
        return true
    }
}
