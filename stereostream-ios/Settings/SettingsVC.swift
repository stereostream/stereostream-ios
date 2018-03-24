//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var hostname: UITextField!
    @IBOutlet weak var route: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func hostnameEditBegun(_ sender: UITextField) {
        route.isEnabled = true
    }

    @IBAction func onSubmit(_ sender: UIButton) {
        Settings.hostname = hostname.text!
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func hostnamePrimaryAction(_ sender: UITextField) {
        route.sendActions(for: .touchUpInside)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
