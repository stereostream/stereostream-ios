//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import UIKit

class CreateRoomVC: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var createBtn: UIButton!

    fileprivate var room: Room!

    @IBAction func nameEdited(_ sender: UITextField) {
        createBtn.isEnabled = true
    }

    @IBAction func onCreate(_ sender: UIButton) {
        room = Room(name: name.text!, owner: Settings.current_user!)
        name.text?.removeAll()

        RoomApi().create(room: room) { (error, room) in
            if let error = error {
                UIViewController.mainErr(error: error)
            } else if let room = room {
                RoomStorage.roomsArray.append(room)

                DispatchQueue.main.async {
                    if let nc = self.navigationController {
                        nc.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
