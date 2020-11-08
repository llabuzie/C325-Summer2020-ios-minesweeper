// 
//   ourModel.swift
//   MinesweeperXtreme
// 
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/18/2020 4:30

import Foundation

class OurModel : NSObject, Codable {
    // int variable keeps track of difficulty
    var difficulty = 0; // 0 - easy    1 - medium    2 - hard
    
    // arrays to track stats, indices match stats to description
    var statNames = [
        "Time in Game (seconds)",
        "Total Games Played",
        "Flags Placed",
        "Correct Flags Placed",
        "Tiles Dug",
        "Bombs Detonated",
        "Games Won",
        "Best Easy Time (seconds)",
        "Best Medium Time (seconds)",
        "Best Hard Time (seconds)"
    ]
    var statValues = [0,0,0,0,0,0,0,0,0,0]
    
    var numBombs = 10 // default for number easy and default difficulty is easy
    var numFlags: Int // number of flags left to place (will go negative if extra flags placed)
    var side = 10 // width of square board
    var currentTimePlayed: Int // keeps track of the length of a specific game
    
    // 2d array of tiles
    var tiles: [[Tile]] = []
    var clickedTiles: Int = 0
    var bombs: [[Int]] = []
    
    // gameState tells us:  -1 is loss, 0 is ongoing, 1 is win
    var gameState: Int
    // lets us know if the user is performing their first click of a game
    var firstClick: Bool
    
    /// saves the entire model in the documents directory
    func save(){
        do{
            // Gets the file location
            let fm = FileManager.default
            let modelUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let data = try PropertyListEncoder().encode(self)
            let file = modelUrl.appendingPathComponent("saveData.plist")
            // writes data to a file called saveData.plist in the documents folder of the sandbox
            try data.write(to: file, options: .atomic)
        } catch {
            print("there was an error saving the file")
        }
    }
    
    /// populates the board with tiles and adds bombs
    func populateBoard() {
        if(self.difficulty == 2) { // hard
            self.numBombs = 100
            self.side = 25
        } else if(self.difficulty == 1) { // medium
            self.numBombs = 40
            self.side = 18
        } else { // easy
            self.numBombs = 10
            self.side = 10
        }
        
        // reset remaining game instance variables
        self.numFlags = self.numBombs
        self.statValues[1] += 1
        self.currentTimePlayed = 0
        self.clickedTiles = 0
        self.bombs = []
        self.gameState = 0
        self.firstClick = true
        
        // creates the Tile array with all tiles bombless
        tiles.removeAll()
        for _ in 0 ... side - 1 {
            var row: [Tile] = []
            for _ in 0 ... side - 1 {
                row.append(Tile(false))
            }
            self.tiles.append(row)
        }

        // this while loop populates board with bombs
        while(self.numBombs > 0){
            let x = Int.random(in: 0 ... side - 1)
            let y = Int.random(in: 0 ... side - 1)
            if (!self.tiles[x][y].isBomb) {
                // if tile not a bomb, set isBomb true and decrement numBombs
                self.tiles[x][y].isBomb = true
                self.bombs.append([x, y])
                self.numBombs -= 1
            }
        }
    }
    /// sets isClicked on all bombs to true (called on game loss)
    func showBombs() {
        self.statValues[5] += 1
        for tile in self.bombs {
            let row = tile[0]
            let column = tile[1]
            if (self.tiles[row][column].isBomb) {
                self.tiles[row][column].wasClicked = true
            }
        }
    }
    
    /// looks at neighbors and then call proper functions/return proper value based on type - abstract version of aoeDig and getBombs; type can be 0, 1, 2, 3
    func checkNeighbors(_ x: Int, _ y: Int, _ type: Int) -> Int {
        var bombCount = 0
        var flagCount = 0
        var xRange = [x - 1, x, x + 1]
        var yRange = [y - 1, y, y + 1]
        
        // check if current tile is on perimeter and update the min/max values accordingly so as not to cause an index out of bounds error
        if (x == 0) {
            xRange.remove(at: 0)
        } else if (x == side - 1) {
            xRange.remove(at: 2)
        }
        if (y == 0) {
            yRange.remove(at: 0)
        } else if (y == side - 1) {
            yRange.remove(at: 2)
        }

        for i in xRange {
            for j in yRange {
                // if called by getBombs increment count
                if (type == 1) {
                    if (self.tiles[i][j].isBomb) {
                        bombCount += 1
                    }
                // if called by getFlagged increment flagCount
                } else if (type == 2) {
                    if (self.tiles[i][j].isFlag) {
                        flagCount += 1
                    }
                // if called by digHandler force a dig on all adjacent non-flag tiles
                } else if (type == 3) {
                    if (!self.tiles[i][j].isFlag) {
                        self.aoeDig(i, j)
                    }
                // if called by aoeDig recurr
                } else {
                    if (!(i == x && j == y)) {
                        aoeDig(i, j)
                    }
                }
            }
        }
        if (type == 1) {
            return bombCount
        } else {
            return flagCount
        }
    }
    
    /// returns number of bomb neighbors
    func getBombs(_ x: Int, _ y: Int) -> Int{
        return checkNeighbors(x, y, 1)
    }
    
    /// handles digging; returns boolean win or not
    func dig(_ x: Int, _ y: Int) -> Bool{
        
        // make sure tile not flagged
        if (!self.tiles[x][y].isFlag){
            
            // check if tile is bomb
            if (self.tiles[x][y].isBomb) {
                self.showBombs()
                self.gameState = -1
                
            } else {
                self.tiles[x][y].wasClicked = true
                self.clickedTiles += 1
                print(clickedTiles)
            }
            // update stats, even if bomb was clicked
            self.statValues[4] += 1
        }
        
        // check if game is over
        return self.winGame()
    }
    
    /// handles when empty tile is clicked and quality of life logical completion
    func aoeDig(_ x: Int, _ y: Int) {
        if (!self.tiles[x][y].wasClicked) {
            // dig selected tile; dig returns true if game is won
            if (self.dig(x, y)) {
                self.gameState = 1
            }
            // handle perimeter tiles
            if (self.getBombs(x, y) == 0) {
                // ignore warning: return value irrelevant, don't need bomb count
                self.checkNeighbors(x, y, 0)
            }
        }
    }
    
    /// reverse the flag boolean and update numFlags
    func flag(_ x: Int, _ y: Int) {

        // use tile array + indexing
        if (self.tiles[x][y].isFlag) {
            self.numFlags += 1
        } else {
            self.numFlags -= 1
            // increments total flags placed
            self.statValues[2] += 1
            
            // increments total correct flags
            if(self.tiles[x][y].isBomb){
                self.statValues[3] += 1
            }
        }
        // reverses the flag state
        self.tiles[x][y].isFlag = !self.tiles[x][y].isFlag
    }
    
    /// returns true on win condition being met; does NOT check if game is lost, that is handled immediately in dig()
    func winGame() -> Bool {
        var win = false
        
        if (self.clickedTiles == ((self.side * self.side) - self.bombs.count)) {
            win = true
        }
        
        // If win is true than every empty tile is clicked
        if (win) {
            
            // flag all bombs
            for tile in bombs {
                let row = tile[0]
                let column = tile[1]
                if (!self.tiles[row][column].isFlag) {
                    self.flag(row, column)
                }
            }
            
            // set statistic of games won
            self.statValues[6] += 1
        }
        return win
    }
    
    override init(){
        self.numFlags = self.numBombs
        self.currentTimePlayed = 0
        self.gameState = 0
        self.firstClick = true
        
        super.init()
        
        // now do all customization after
        self.populateBoard()
    }
}

/// This class is used to store values for a specific tile
class Tile : Codable {
    var isBomb:Bool
    var isFlag:Bool = false
    var wasClicked:Bool = false
    
    init(_ bomb: Bool){
        self.isBomb = bomb
    }
}
