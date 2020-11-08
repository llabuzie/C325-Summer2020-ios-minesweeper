// 
//   MenuViewController.swift
//   MinesweeperXtreme
// 
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/18/2020 4:30

import UIKit

class MenuViewController: UIViewController {
    var appDelegate: AppDelegate?
    var ourModel: OurModel?
    
    
    @IBOutlet weak var easyColor : UIButton? // buttton for easy
    @IBOutlet weak var mediumColor : UIButton? // button for medium
    @IBOutlet weak var hardColor : UIButton? // button for hadr
    
    // called when easy button pushed
    @IBAction func setEasy(_ sender: Any) {
        // sets difficulty to easy
        self.ourModel!.difficulty = 0
        // resets the board
        self.ourModel!.populateBoard()
        self.getDrawGameBoard()
        // changes the button colors
        self.easyColor?.backgroundColor = UIColor.green
        self.mediumColor?.backgroundColor = UIColor.lightGray
        self.hardColor?.backgroundColor = UIColor.lightGray
    }
    // called when medium button pushed
    @IBAction func setMedium(_ sender: Any) {
        // sets difficulty to medium
        self.ourModel!.difficulty = 1
        // resets the board
        self.ourModel!.populateBoard()
        self.getDrawGameBoard()
        // changes the button colors
        self.easyColor?.backgroundColor = UIColor.lightGray
        self.mediumColor?.backgroundColor = UIColor.green
        self.hardColor?.backgroundColor = UIColor.lightGray
    }
    // called when hard button pushed
    @IBAction func setHard(_ sender: Any) {
        // sets difficulty to hard
        self.ourModel!.difficulty = 2
        // resets the board
        self.ourModel!.populateBoard()
        self.getDrawGameBoard()
        // changes the button colors
        self.easyColor?.backgroundColor = UIColor.lightGray
        self.mediumColor?.backgroundColor = UIColor.lightGray
        self.hardColor?.backgroundColor = UIColor.green
    }
    
    // Calls redraw board from the GameViewController to update the gameScene accordingly
    func getDrawGameBoard () {
        // extend from Tab Bar Controller
        if let tabBarController = self.tabBarController as UITabBarController? {
            if let gvc = tabBarController.viewControllers?[2] as! GameViewController? {
                gvc.drawGameBoard()
            }
        }
    }
    
    // runs on load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // gets our model
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
        
        // highlight difficulty based on model on load
        if (self.ourModel?.difficulty == 2) {
            self.hardColor?.backgroundColor = UIColor.green
        } else if (self.ourModel?.difficulty == 1) {
            self.mediumColor?.backgroundColor = UIColor.green
        } else {
            self.easyColor?.backgroundColor = UIColor.green
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
