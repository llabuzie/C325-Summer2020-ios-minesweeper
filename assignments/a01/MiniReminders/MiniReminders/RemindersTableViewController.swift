//  RemindersTableViewController.swift
//  MiniReminders
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/5/2020 3:30

import UIKit

class RemindersTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // grab the AppDelegate
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        // from the AppDelegate reference, obtain reference to model instance:
        let ltoDoList = lAppDelegate.myRemindersData.toDoList
        
        return ltoDoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCellView", for: indexPath) as! MiniRemindersTableViewCell
        
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        // from the AppDelegate reference, obtain reference to model instance:
        let ltoDoList = lAppDelegate.myRemindersData.toDoList
        
        
        // Set cell text labels from @IBOutlet UILables
        cell.reminderLabel.text = ltoDoList[indexPath.row].content
        cell.categoryLabel.text = ltoDoList[indexPath.row].category
        cell.dateLabel.text = ltoDoList[indexPath.row].date.description
        
        // Make date readable
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // input style
        let printDateFormatter = DateFormatter()
        printDateFormatter.dateFormat = "MMM, dd hh:mm a" // output prefered
        if let date = getDateFormatter.date(from: "\(ltoDoList[indexPath.row].date)"){
            // set cell label text
            cell.dateLabel.text = printDateFormatter.string(from:date)
        }
        
        // logic to show completion of task
        if (ltoDoList[indexPath.row].complete) {
            cell.doneLabel.text = "Done!"
        } else {
            cell.doneLabel.text = "Not yet done"
        }

        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
