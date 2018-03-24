//
//  Created by Samuel Marks
//  Copyright © 2018. Apache License 2.0.
//

import UIKit

class RoomTableVC: UITableViewController {
    @IBAction func onLogout(_ sender: UIButton) {
        Settings.access_token = nil
        redirIfUnAuth()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Settings.loadCache()
        loadRooms()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        // navigationItem.title = "Rooms"
        // roomsTable.dataSource = self

        // self.tableView(RoomTableVC.self, forCellReuseIdentifier: "cell")
        /*RoomStorage.roomsArray = [
            Room(name: "womb-with-a-view", owner: "foo@bar.com"),
            Room(name: "viewed-room", owner: "foo@bar.com"),
            Room(name: "westmead-real", owner: "can@haz.com")
        ]*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return RoomStorage.roomsArray.count
    }

    private func loadRooms() {
        RoomsApi().read { (error: ErrorResponse?, rooms: Rooms?) in
            if let error = error {
                UIViewController.mainErr(error: error)
            } else if let rooms = rooms {
                if rooms.rooms.count > 0 {
                    DispatchQueue.main.async {
                        RoomStorage.roomsArray = rooms.rooms
                        self.tableView.reloadData()
                    }
                }
                print(RoomStorage.roomsArray)
            }
            // TODO: Load a "no rooms available; create one" view
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RoomTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RoomTableViewCell else {
            fatalError("The dequeued cell is not an instance of RoomTableViewCell.")
        }

        let room: Room = RoomStorage.roomsArray[indexPath.row]

        cell.nameLabel.text = room.name
        cell.ownerLabel.text = room.owner

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
