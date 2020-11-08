//
//  ourModel.swift
//  MinesweeperXtreme
//
// Harrison Yelton (hayelton@iu.edu) and Louis Labuzienski (llabuzie@iu.edu)
// Submitted 6/16/2020 11:59

import Foundation

class OurModel : NSObject, Codable {
    //  int variable keeps track of difficulty
    var difficulty = 0; // 0 - easy    1 - medium    2 - hard
    
    // arrays to track stats, indices match stats to description
    var statNames = [
        "Time in Game",
        "Total Games Played",
        "Flags Placed",
        "Correct Flags Placed",
        "Tiles Dug",
        "Bombs Detonated",
        "Games Won",
        "Best Easy Time",
        "Best Medium Time",
        "Best Hard Time"
    ]
    var statValues = [0,0,0,0,0,0,0,0,0,0]
    
    var numBombs = 10 // default for number easy and default difficulty is easy
    var numFlags : Int // not sure if this will be needed??
    var side = 10 // width of square board
    
    //2d array of tiles
    var tiles:[[Tile]] = []
    
    //this function will save the entire model in the documents directory
    func save(){
        do{
            let fm = FileManager.default
            let modelUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let data = try PropertyListEncoder().encode(self)
            let file = modelUrl.appendingPathComponent("saveData.plist")
            try data.write(to: file, options: .atomic)
        }catch{
            print("there was an error saving the file")
        }
    }
    
    //this function will populate the board with tiles and then add the bombs
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
        self.numFlags = self.numBombs
        // creates the Tile array with all tiles bombless
        tiles.removeAll()
        for _ in 0 ... side - 1 {
            var row : [Tile] = []
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
                self.numBombs -= 1
            }
        }
    }
    //this function will show all bombs (for when the user clicks on a bomb) will basically set all bombs to wasClicked so the view controller knows to make it visible?
    func showBombs(){
        self.statValues[5] += 1
        for i in 0 ... side - 1 {
            for j in 0 ... side - 1 {
                if (self.tiles[i][j].isBomb) {
                    self.tiles[i][j].wasClicked = true
                }
            }
        }
    }
    
    func getBombs(_ x: Int, _ y: Int) -> Int{
        //look at neighbors and count how many are bombs
        var count = 0
        var minX = x - 1
        var minY = y - 1
        var maxX = x + 1
        var maxY = y + 1
        // check if current tile is on perimeter
        if (x == 0 || x == side - 1 || y == 0 || y == side - 1) {
            if (x == 0) {
                minX = x
            } else if (x == side - 1) {
                maxX = x
            } else if (y == 0) {
                minY = y
            } else if (y == side - 1) {
                maxY = y
            }
        }
        // increment count for all neighbors
        for i in minX ... maxX {
            for j in minY ... maxY {
                if (self.tiles[i][j].isBomb) {
                    count += 1
                }
            }
        }
        return count
    }
    
    func dig(_ x: Int, _ y: Int) -> Bool{
        //check if tile is flagged
        if(self.tiles[x][y].isFlag){
            return false
        } else {
            // check if tile is bomb
            if (self.tiles[x][y].isBomb) {
                return true
            } else {
                self.tiles[x][y].wasClicked = true
                self.statValues[4] += 1
                return false
            }
        }
    }
    
    // handles when empty tile is clicked and quality of life logical completion
    func aoeDig(_ x: Int, _ y: Int) {
        if (!self.tiles[x][y].wasClicked) {
            if (getBombs(x, y) != 0) {
                // handle perimeter tiles
                self.dig(x, y)
            } else {
                self.dig(x, y)
                var minX = x - 1
                var minY = y - 1
                var maxX = x + 1
                var maxY = y + 1
                // check if current tile is on perimeter
                if (x == 0 || x == side - 1 || y == 0 || y == side - 1) {
                    if (x == 0) {
                        minX = x
                    } else if (x == side - 1) {
                        maxX = x
                    } else if (y == 0) {
                        minY = y
                    } else if (y == side - 1) {
                        maxY = y
                    }
                }
                // call aoeDig on neighbors
                for i in minX ... maxX {
                    for j in minY ... maxY {
                        aoeDig(i, j)
                    }
                }
            }
        }
    }
    
    // reverse the flag boolean and update numFlags
    func flag(_ x: Int, _ y: Int) {
        if (self.tiles[x][y].isFlag) { // use tile array + indexing
            self.numFlags -= 1
        } else {
            self.numFlags += 1
        }
        self.tiles[x][y].isFlag = !self.tiles[x][y].isFlag
    }
    
    override init(){
        self.numFlags = self.numBombs
        super.init()
        
        // now do all customization after
        self.populateBoard()
    }
}


class Tile : Codable {
    var isBomb:Bool
    var isFlag:Bool = false
    var wasClicked:Bool = false
    
    init(_ bomb: Bool){
        self.isBomb = bomb
    }
}
