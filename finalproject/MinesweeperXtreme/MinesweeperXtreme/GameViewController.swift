//
//   GameViewController.swift
//   MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/18/2020 4:30

import UIKit
import SpriteKit
import GameplayKit
import Foundation
import AVKit
import AVFoundation

class GameViewController: UIViewController {
    var appDelegate: AppDelegate?
    var ourModel: OurModel?
    var timer = Timer()
    
    @IBOutlet weak var timerLabel: UILabel! // shows the time it has taken for the current game
    @IBOutlet weak var resetButton: UIButton! // shows an emoji to show faces when clicking or when the game is lost/won
    @IBOutlet weak var imageView: UIImageView! // Shows a rectangle that will be green when the game is won, and red when the game is lost
    @IBOutlet weak var flagLabel: UILabel! // shows how many flags are left to be placed on all the bombs
    
    /// This function resets the game by reloading parts of the view and updating the model
    @IBAction func resetGame(_ sender: Any) {
        self.viewWillAppear(true) // reloads certain view elements
        self.populateBoard() // re-populates the board and resets certain game data
        self.drawGameBoard() // reinstantiates the gameScene
        self.resetButton.setTitle("🧐", for: UIButton.State.normal)
    }
    
    /// Called when GameViewController is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // gets our model
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.ourModel = self.appDelegate?.ourModel
        
        // creates a timer for keeping track of time
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        // if game is over and you exit the app it will reload on launch
        if (self.ourModel!.gameState != 0) {
            self.viewWillAppear(true)
            self.populateBoard()
        }
        self.resetButton.setTitle("🧐", for: UIButton.State.normal)
        self.drawGameBoard()// instantiates the gameScene
    }
    
    /// Draws the game board when a new game is first loaded
    func drawGameBoard() {
        // extend from Tab Bar Controller
        if let tabBarController = self.tabBarController as UITabBarController? {
            if let view = tabBarController.viewControllers?[2].view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = GameScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // retrieve GameScene
                    scene.gvc = self
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        drawRect(0)
    }

    /// Framework Core Graphpics - creates green rectangle when game is won, red rectangle when game is lost, and is invisible otherwise
    func drawRect(_ gameState: Int) {

        // checks if game is in progress
        if(gameState != 0){

            // creates renderer of specified size
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 794, height: 80))
            // using the rendering we are able to add elements
            let img = renderer.image { context in

                // add a rectangle with the same size as the renderer
                let rectangle = CGRect(x: 0, y: 0, width: 794, height: 80)
                // changes the color of the rectangle
                if(gameState == -1){
                    context.cgContext.setFillColor(red: 255, green: 0, blue: 0, alpha: 0.1)
                } else if(gameState == 1){
                    context.cgContext.setFillColor(red: 0, green: 255, blue: 0, alpha: 0.3)
                }
                
                // sets line width
                context.cgContext.setLineWidth(0)
                // adds the rectangle to the context of the renderer
                context.cgContext.addRect(rectangle)
                // draws the path created
                context.cgContext.drawPath(using: .fillStroke)
                }

            // updates the image view image with our new image
            imageView.image = img
        }else{

            // updates image view image with nothing inside
            imageView.image = nil
        }
    }

    /// This plays short video for when game is lost
    func playBombVideo() {

        // gets the video url
        guard let url = Bundle.main.path(forResource: "explosion", ofType:"mp4") else {
            print("the file was not found in the bundle")
            return
        }

        // creates player and player layer to update the view
        let player = AVPlayer(url: URL(fileURLWithPath: url))
        let playerLayer = AVPlayerLayer()
        playerLayer.player = player
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds

        // plays the video
        player.play()

        // ends the video and removes from the view after 1 second
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            player.pause()
            playerLayer.removeFromSuperlayer()
        }
    }
    

    /// called whenever the view is about to appear
    override func viewWillAppear(_ animated : Bool) {
        // update flagLabel when switching tabs
        self.flagLabel.text = "Flags Remaining: \(self.ourModel!.numFlags)"
        self.resetButton.setTitle("🧐", for: UIButton.State.normal)
    }
    
    /// gets game difficulty
    func getDifficulty() -> Int {
        return self.ourModel!.difficulty
    }
    
    /// gets stats array
    func getStats () -> [Int] {
        return self.ourModel!.statValues
    }
    
    /// gets board side length
    func getSide () -> Int {
        return self.ourModel!.side
    }
    
    /// gets currentTimePlayed
    func getTime() -> Int {
        return self.ourModel!.currentTimePlayed
    }
    
    /// gets a specific tile from model.tiles
    func getTile(_ x: Int, _ y: Int) -> Tile {
        return self.ourModel!.tiles[x][y]
    }
    
    /// returns the state of the game
    func getGameState() -> Int {
        return self.ourModel!.gameState
    }
    
    /// returns the state of the first click
    func getFirstClick() -> Bool {
        return self.ourModel!.firstClick
    }
    
    /// calls save method from OurModel
    func save() {
        self.ourModel!.save()
    }

    /// calls board reset from OurModel
    func populateBoard() {
        self.ourModel!.populateBoard()
    }
    
    // gets the status of a tile (
    // 1: flag
    // 2: not bomb and not clicked
    // 3: was clicked and is bomb
    // 4: not clicked and not flag
    func getTileStatus(_ row: Int,_ column: Int) -> Int{
        // gets the status of a tile from the model
        let tile = self.ourModel!.tiles[row][column]
        if(tile.isFlag){
            return 1
        } else if(tile.wasClicked && !tile.isBomb){
            return 2
        } else if(tile.wasClicked && tile.isBomb){
            return 3
        } else{
            // must be not clicked or flag
            return 4
        }
    }
    
    /// returns the number of bombs adjacent to a tile
    func getNumber(_ row: Int,_ column: Int) -> Int{
        return self.ourModel!.getBombs(row, column)
    }
    
    /// returns the number of flags adjacent to a tile
    func getFlagged(_ row: Int, _ column: Int) -> Int {
        return self.ourModel!.checkNeighbors(row, column, 2)
    }
    
    /// flags a tile if unclicked and returns true if flag status changes
    func setFlag (_ row: Int, _ column: Int) -> Bool {
        let tile = self.getTile(row, column)
        if (!tile.wasClicked) {
            self.ourModel!.flag(row, column)
            self.flagLabel.text = "Flags Remaining: \(self.ourModel!.numFlags)"
            
            return true
        } else {
            return false
        }
    }
    
    /// increments the number of seconds played by one
    func setTime() {
        self.ourModel!.currentTimePlayed += 1
    }
    
    /// increments the stat value at the given index
    func setStats(_ index: Int, _ value: Int) {
        self.ourModel!.statValues[index] += value
    }
    
    /// updates model first click value
    func setFirstClick() {
        self.ourModel!.firstClick = false
    }
    
    /// deals with first click
    func handleFirstClick(_ row: Int, _ column: Int) {
        let tile = self.getTile(row, column)
        if (tile.isBomb) {
            // move bomb
            tile.isBomb = false
            var newx = Int.random(in: 0 ... self.getSide() - 1)
            var newy = Int.random(in: 0 ... self.getSide() - 1)
            let range = self.getSide() - 5 ... self.getSide() + 5
            
            // check that new coordinates are at least five tiles away
            while((range.contains(newx)) || (range.contains(newy))) {
                if (range.contains(newx)) {
                    // new x coordinate
                    newx = Int.random(in: 0 ... self.getSide() - 1)
                }
                if (range.contains(newy)) {
                    // new y coordinate
                    newy = Int.random(in: 0 ... self.getSide() - 1)
                }
            }
        }
    }
    
    /// decides which dig functions to call and handles proper updates
    func digHandler (_ row: Int, _ column: Int) {
        // on the first click allow the user a free dig
        if (self.getFirstClick()) {
            self.handleFirstClick(row, column)
            self.setFirstClick()
        }
        if (self.getNumber(row, column) == self.getFlagged(row, column)) {
            // dig all adjacent squares not flagged if the number of adjacent flags is equal to the number of adjacent bombs
            self.ourModel!.checkNeighbors(row, column, 3)
        } else {
            // call aoeDig normally
            self.ourModel!.aoeDig(row, column)
        }
        // updates the rectangle after winning or losing
        self.drawRect(self.getGameState())
        if(self.ourModel!.gameState == -1){
            playBombVideo()
        }

    }
    
    /// updates best time based on index given
    func timerHelp(_ stat: Int) {
        if ((self.getTime() < self.getStats()[stat] || self.getStats()[stat] == 0) && self.getGameState() == 1) {
            self.setStats(stat, self.getTime())
        }
    }
    
    /// counts seconds while in-game and updates stats array
    @objc func fireTimer(_ sender : Any) {
        // increments currentTimePlayed
        if (self.getGameState() == 0) {
            self.setTime()
        }
        
        // updates total time played stat
        self.setStats(0, 1)
        
        // updates timer label
        self.timerLabel.text = "Timer: \(self.getTime())"
        
        // updates statistics for best (difficulty goes here) game time
        if (self.getDifficulty() == 0) {
            self.timerHelp(7)
        } else if (self.getDifficulty() == 1) {
            self.timerHelp(8)
        } else {
            self.timerHelp(9)
        }
        // saves our model
        self.ourModel!.save()
    }
    
    
    // function a part of initial setup
    override var shouldAutorotate: Bool {
        return true
    }
    // function a part of initial setup
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    // funciton a part of initial setup
    override var prefersStatusBarHidden: Bool {
        return true
    }
}