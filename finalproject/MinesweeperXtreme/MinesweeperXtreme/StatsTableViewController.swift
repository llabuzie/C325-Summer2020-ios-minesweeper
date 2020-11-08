// 
//   StatsTableViewController.swift
//   MinesweeperXtreme
// 
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/18/2020 4:30

import UIKit

class StatsTableViewController: UITableViewController {
    var appDelegate: AppDelegate?
    var ourModel: OurModel?

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
        
        // We only have one section so number of sections is 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // gets model
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
        // counts the number of stat values that need to be displayed and makes that the number of rows
        return ourModel!.statValues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // gets model
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
        
        // Configure the cell...
        // set title to proper stat name and subtitle to the value
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath)
        cell.textLabel?.text = "\(ourModel!.statNames[indexPath.row])"
        cell.detailTextLabel?.text = "\(ourModel!.statValues[indexPath.row])"

        // Configure the cell...

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // extend from Tab Bar Controller
        if let tabBarController = self.tabBarController as UITabBarController? {
            if let view = tabBarController.viewControllers?[1].view as! UITableView? {
                view.reloadData() // reloads the data every time we are about to enter it so that it stays up to date every time we enter the stats view
            }
        }
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
