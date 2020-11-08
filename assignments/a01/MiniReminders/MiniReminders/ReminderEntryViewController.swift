//  ReminderEntryViewController.swift
//  MiniReminders
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/5/2020 3:30

import UIKit

class ReminderEntryViewController: UIViewController {

    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBAction func addReminder(_ sender: UIButton) {
        // get a reference to the AppDelegate
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        // from the AppDelegate reference, obtain reference to model instance:
        let lDataModel = lAppDelegate.myRemindersData
        
        lDataModel.addEvent(content: self.content.text ?? "Smile!",
                            category: self.category.text ?? "Self Care",
                            dueDate: self.dueDatePicker.date)
        
        // reload the table view
        if let lContainerSplitViewController = self.splitViewController {
            // as the array of View Controllers isn't an optional, there's no need to unwrap it
            let lSiblingViewControllers = lContainerSplitViewController.viewControllers
            //print(lSiblingViewControllers) // debugging print statement
            // the master View Controller should be in the first index position
            if let lNavViewController = lSiblingViewControllers[0] as? UINavigationController {
                //print("We made it this far") // Another debug print statement
                if let lTableViewController = lNavViewController.viewControllers[0] as? RemindersTableViewController {
                    if let lTableView = lTableViewController.view as? UITableView {
                        lTableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

