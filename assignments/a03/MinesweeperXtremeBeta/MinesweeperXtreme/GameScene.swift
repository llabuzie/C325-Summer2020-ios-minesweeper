//
//  GameScene.swift
//  MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/16/2020 11:59

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mainLayer = SKTileMapNode()
    var gvc : GameViewController?
    
    override func didMove(to view: SKView) {
        // handle taps
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // handle presses
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePressFrom(recognizer:)))
        pressGestureRecognizer.minimumPressDuration = 0.25
        view.addGestureRecognizer(pressGestureRecognizer)

        let tileSet = SKTileSet(named: "Sample Grid Tile Set")!
        let tileSize = CGSize(width: 128, height: 128)
        
        // use sidelength getter
        let side = gvc!.getSide()
        
        // update with difficulty
        let columns = side
        let rows = side
        let grassTiles = tileSet.tileGroups.first { $0.name == "GrassWithBorder"}
        mainLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        mainLayer.fill(with: grassTiles)
        addChild(mainLayer)
        
        // update with difficulty
        if (side == 25) {
            mainLayer.xScale = 0.23
            mainLayer.yScale = 0.23
        } else if (side == 18) {
            mainLayer.xScale = 0.3
            mainLayer.yScale = 0.3
        } else {
            mainLayer.xScale = 0.5
            mainLayer.yScale = 0.5
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func isInBounds(_ row: Int, _ column: Int) -> Bool {
        let side = self.gvc!.getSide()
        
        // check for valid coordinates
        if (row < side && row >= 0 && column < side && column >= 0) {
            return true
        } else {
            return false
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        // update reset button
        gvc?.resetButton.titleLabel?.text = "😨"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        // if input is still continuing, do nothing
        if recognizer.state != .ended {
            return
        }
        
        // get location of tap
        let recognizorLocation = recognizer.location(in: recognizer.view!)
        
        // convert location to be relative to the game scene
        let location = self.convertPoint(fromView: recognizorLocation)
        
        // convert location to be relative to the main layer of the TileMap
        let position = self.convert(location, to: mainLayer)
        
        // Mapping location to the closest column and row
        let column = mainLayer.tileColumnIndex(fromPosition: position)
        let row = mainLayer.tileRowIndex(fromPosition: position)
        
        if (self.isInBounds(row, column)) {
            // options:
                // -1 is bomb
                // 0 is sand
                // else number to be drawn on sand
            let sandTiles = mainLayer.tileSet.tileGroups.first { $0.name == "Sand0"}
            mainLayer.setTileGroup(sandTiles, forColumn: column, row: row)
        }
        gvc?.resetButton.titleLabel?.text = "🧐"
    }
    
    @objc func handlePressFrom(recognizer: UILongPressGestureRecognizer) {
        // if input is still continuing, do nothing
        if recognizer.state != .ended {
            return
        }
        
        // get location of press
        let recognizorLocation = recognizer.location(in: recognizer.view!)
        
        // convert location to be relative to the game scene
        let location = self.convertPoint(fromView: recognizorLocation)
        
        // convert location to be relative to the main layer of the TileMap
        let position = self.convert(location, to: mainLayer)
        
        // Mapping location to the closest column and row
        let column = mainLayer.tileColumnIndex(fromPosition: position)
        let row = mainLayer.tileRowIndex(fromPosition: position)
        if (self.isInBounds(row, column)) {
            if (gvc!.setFlag(row, column)) {
                if (mainLayer.tileGroup(atColumn: column, row: row)?.name != "Flag") {
                    let flag = mainLayer.tileSet.tileGroups.first { $0.name == "Flag"}
                    mainLayer.setTileGroup(flag, forColumn: column, row: row)
                } else {
                    let grass = mainLayer.tileSet.tileGroups.first { $0.name == "GrassWithBorder"}
                    mainLayer.setTileGroup(grass, forColumn: column, row: row)
                }
            }
        }
        gvc?.resetButton.titleLabel?.text = "🧐"
    }
}
