// 
//   GameScene.swift
//   MinesweeperXtreme
// 
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/18/2020 4:30

import SpriteKit
import GameplayKit

/// interacts with the board itself and draws the board; contains touch handlers for the tileMap and interacts with the GameViewController
class GameScene: SKScene {
    
    var mainLayer = SKTileMapNode()
    var gvc : GameViewController?
    
    /// This runs when the GameScene is loaded
    override func didMove(to view: SKView) {
        
        // set up tap handler
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // set up press handler
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePressFrom(recognizer:)))
        pressGestureRecognizer.minimumPressDuration = 0.25
        view.addGestureRecognizer(pressGestureRecognizer)

        // This sets our tileSet to the Sample Grid Tile Set which came in by default, but we added our own assets to the tile set
        let tileSet = SKTileSet(named: "Sample Grid Tile Set")!
        // Using Core Graphics this updates the size of a tile
        let tileSize = CGSize(width: 128, height: 128)
        
        // use sidelength getter
        let side = gvc!.getSide()
        
        // sets the size (rows and columns) based on side propery which is dependent on difficulty
        let columns = side
        let rows = side
        // This gets a specific tilegroup from a tileset
        let grassTiles = tileSet.tileGroups.first { $0.name == "GrassWithBorder"}
        // This will create a new SKTileMapNode that uses the previously created arguments
        self.mainLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        // This fills the entire mainLayer with grass tiles
        self.mainLayer.fill(with: grassTiles)
        // redraw board
        self.reDraw(side)
        // adds the layer to the view
        addChild(self.mainLayer)
        
        // update with difficulty to scale properly (scale works best for iPad Air (3rd Generation)
        if (side == 25) {
            self.mainLayer.xScale = 0.23
            self.mainLayer.yScale = 0.23
        } else if (side == 18) {
            self.mainLayer.xScale = 0.3
            self.mainLayer.yScale = 0.3
        } else {
            self.mainLayer.xScale = 0.5
            self.mainLayer.yScale = 0.5
        }
    }
    
    /// updates the view for a single tile
    func drawSingle(_ row: Int, _ column: Int) {
        let status = self.gvc?.getTileStatus(row, column)
        if (status == 1) {
            
            // draw tile as flag
            let tileGroup = self.mainLayer.tileSet.tileGroups.first { $0.name == "Flag"}
            self.mainLayer.setTileGroup(tileGroup, forColumn: column, row: row)
            
        } else if (status == 2) {
            
            // draw tile as sand variant
            let tile = "Sand\(self.gvc!.getNumber(row, column))"
            let tileGroup = self.mainLayer.tileSet.tileGroups.first { $0.name == tile}
            self.mainLayer.setTileGroup(tileGroup, forColumn: column, row: row)
            
        } else if (status == 3) {
            
            // draw tile as revealed bomb
            let tileGroup = self.mainLayer.tileSet.tileGroups.first { $0.name == "Bomb"}
            self.mainLayer.setTileGroup(tileGroup, forColumn: column, row: row)

        } else {
            
            // draw tile as unclicked
            let tileGroup = self.mainLayer.tileSet.tileGroups.first { $0.name == "GrassWithBorder"}
            self.mainLayer.setTileGroup(tileGroup, forColumn: column, row: row)
        }
    }
    
    /// updates the view for all tiles
    func reDraw(_ side: Int) {
        
        // draw the game as either saved or new board
        for row in 0 ... side - 1 {
            for column in 0 ... side - 1 {
                self.drawSingle(row, column)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    /// checks if clicked coordinates are on the game board
    func isInBounds(_ row: Int, _ column: Int) -> Bool {
        
        let side = self.gvc!.getSide()
        
        // check for valid coordinates
        if (row < side && row >= 0 && column < side && column >= 0) {
            return true
        } else {
            return false
        }
    }
    
    /// touchesBegan helper
    func touchDown(atPoint pos : CGPoint) {
        // update reset button
        self.gvc?.resetButton.titleLabel?.text = "😨"
    }
    
    /// updates view when touch envelope beings
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    /// handles a tap gesture
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        // if input is still continuing, do nothing
        if recognizer.state != .ended {
            return
        }
        
        // only act while game is active
        if (self.gvc!.getGameState() == 0) {
            
            // get location of tap
            let recognizorLocation = recognizer.location(in: recognizer.view!)
            
            // convert location to be relative to the game scene
            let location = self.convertPoint(fromView: recognizorLocation)
            
            // convert location to be relative to the main layer of the TileMap
            let position = self.convert(location, to: self.mainLayer)
            
            // Mapping location to the closest column and row
            let row = self.mainLayer.tileRowIndex(fromPosition: position)
            let column = self.mainLayer.tileColumnIndex(fromPosition: position)
            
            // check for valid location
            if (self.isInBounds(row, column)) {
                
                // Perform a dig action
                gvc!.digHandler(row, column)
                
                // if game is won, manually set labels to reflect model
                if (self.gvc!.getGameState() == 1) {
                    self.gvc!.flagLabel.text = "Flags Remaining: 0"
                    self.gvc?.resetButton.setTitle("😎", for: UIButton.State.normal)
                }
                
                // redraw the entire board after dig in case aoeDig() updated the entire board
                self.reDraw(self.gvc!.getSide())
            }
            self.gvc?.resetButton.titleLabel?.text = "🧐"
        }
    }
    
    /// handles a long press gesture
    @objc func handlePressFrom(recognizer: UILongPressGestureRecognizer) {
        // if input is still continuing, do nothing
        if recognizer.state != .ended {
            return
        }
        
        // only act while game is active
        if (self.gvc!.getGameState() == 0) {

            // get location of press
            let recognizorLocation = recognizer.location(in: recognizer.view!)
            
            // convert location to be relative to the game scene
            let location = self.convertPoint(fromView: recognizorLocation)
            
            // convert location to be relative to the main layer of the TileMap
            let position = self.convert(location, to: self.mainLayer)
            
            // Mapping location to the closest column and row
            let row = self.mainLayer.tileRowIndex(fromPosition: position)
            let column = self.mainLayer.tileColumnIndex(fromPosition: position)

            // check for valid location
            if (self.isInBounds(row, column)) {
                // use the view controller to place or remove a flag and update the single tile view
                if (self.gvc!.setFlag(row, column)) {
                    self.drawSingle(row, column)
                }
            }
            self.gvc?.resetButton.titleLabel?.text = "🧐"
        }
    }
}