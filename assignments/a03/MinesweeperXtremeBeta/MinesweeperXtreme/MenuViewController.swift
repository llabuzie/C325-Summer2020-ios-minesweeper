//
//  MenuViewController.swift
//  MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/16/2020 11:59

import UIKit

class MenuViewController: UIViewController {
    var appDelegate: AppDelegate?
    var ourModel: OurModel?
    
    
    @IBOutlet weak var easyColor : UIButton?
    @IBOutlet weak var mediumColor : UIButton?
    @IBOutlet weak var hardColor : UIButton?
    
    @IBAction func setEasy(_ sender: Any) {
        self.ourModel!.difficulty = 0
        self.ourModel!.populateBoard()
        self.ourModel!.save()
        self.easyColor?.backgroundColor = UIColor.green
        self.mediumColor?.backgroundColor = UIColor.lightGray
        self.hardColor?.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func setMedium(_ sender: Any) {
        self.ourModel!.difficulty = 1
        self.ourModel!.populateBoard()
        self.ourModel!.save()
        self.easyColor?.backgroundColor = UIColor.lightGray
        self.mediumColor?.backgroundColor = UIColor.green
        self.hardColor?.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func setHard(_ sender: Any) {
        self.ourModel!.difficulty = 2
        self.ourModel!.populateBoard()
        self.ourModel!.save()
        self.easyColor?.backgroundColor = UIColor.lightGray
        self.mediumColor?.backgroundColor = UIColor.lightGray
        self.hardColor?.backgroundColor = UIColor.green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
        
        // highlight difficulty
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
