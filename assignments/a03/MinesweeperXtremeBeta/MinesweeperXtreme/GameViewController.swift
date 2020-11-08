//
//  GameViewController.swift
//  MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/16/2020 11:59

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var appDelegate: AppDelegate?
    var ourModel: OurModel?
    
    @IBOutlet weak var resetButton : UIButton!
    
    @IBAction func resetGame(_ sender: Any) {
        self.viewWillAppear(true)
        self.ourModel!.populateBoard()
        self.ourModel!.statValues[1] += 1
        self.ourModel!.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
    }
    
    override func viewWillAppear(_ animated : Bool) {
        // extend from Tab Bar Controller
        if let tabBarController = self.tabBarController as UITabBarController? {
            if let view = tabBarController.viewControllers?[2].view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = GameScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // retrieve GameScene
                    scene.gvc = self
                    
                    // redraw
                    scene.didMove(to: view)
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }
    
    // gets board side length
    func getSide () -> Int {
        return self.ourModel!.side
    }
    
    func getFlags () -> Int {
        return self.ourModel!.numFlags
    }
    
    // flags a tile and returns the number of remaining flags
    func setFlag (_ row: Int, _ column: Int) -> Bool {
        let tile = self.ourModel!.tiles[row][column]
        if (!tile.wasClicked) {
            self.ourModel!.flag(row, column)
            
            return true
        } else {
            return false
        }
    }
    
    func digHandler (_ row: Int, _ column: Int) -> Int {
        // need to figure out how to implement aoeDig
        let tile = self.ourModel!.tiles[row][column]
        if (tile.isBomb) {
            return -1
        } else {
            return self.ourModel!.getBombs(row, column)
        }
    }
    
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
