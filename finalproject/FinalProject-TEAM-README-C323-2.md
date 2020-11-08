# C323 / Summer 2020
## Team Brunswick Final Remarks

### App Instructions
Upon opening the app, you will have the option to choose from three difficulty options. This decision will persist after closing the app once made. At the bottom of the screen there are three tabs you can switch between to see different displays. The first icon is the menu you start on. Choosing the second tab option will display your "career stats" that you have scored while playing the game. Choosing the third tab will start a new game of Minesweeper based on the difficulty setting you chose earlier. 

If you close the app before either winning or losing the game, it will be saved for you to complete or start over when you open the app again. If you would like to reset the game, or if you lose and want to play more, then just tap the emoji button at the top of the game board. This will start a new game with the same difficulty as is selected on the menu tab. 

**Rules of Minesweeper Xtreme:**
The object of the game is to clear all safe tiles without digging up a mine. To do this, you are given clues. If you dig a tile and it has a number on it, that means that there are that many bombs on adjacent tiles in any direction. If you think you know that a tile is in fact a mine, you can put a flag on it. This will make sure you can't accidentally dig that tile. To dig on a tile, tap it. To put a flag over a tile, hold down on the tile briefly and release it. 

*Special conditions:*
* If you dig a tile and it doens't have a bomb under it or nearby, then your team of bomb defusal experts will help you automatically clear all tiles nearby that are not near bombs.
* If you have dug up a numbered tile, and the number of flags adjacent to the tile is equal to the number on the tile, you can tap it again to uncover all the tiles touching the numbered tile that do not have flags.
  * **BE CAREFUL!!** Just because you have placed flags does not guarantee that they are placed correctly. Be sure before you tap!

### Xcode environment
 * 11.3.1
 * Default compile settings
 * *Use IPad Air (3rd Gen) Simulator*
 * No physical hardware required
 
### Required Features
* MVC Design
* User Interface
  * 3 separate views
    * Game View
    * Stats View (**table view controller**)
    * Menu View
  * Tab Bar Controller
  * Input
    * Menu Buttons for difficulty
    * reset button in Game View
    * Tap handler
    * Long Press handler
  * Output
    * Menu View
      * Title labels
      * Difficulty shown by button color
    * Stats View
      * Stat Title
      * Stat Subtitle (value)
    * Game View
      * Tile Map
      * Reset Button updates
      * Timer Label
      * Flag Label
      * Colored win/loss overlay (Core Graphics)
* Persistant storage
  * Saved model in `plist` file
  * Located in Sandbox folder
* Frameworks
  * Used CoreGraphics
    * Used in the colored win/loss overlay rectange in the Game View
    * Used in setting tile size on the game board
  * Used SpriteKit
    * Allowed us to use Tile Map
    * Extremely central to core game functionality
    * Added custom tiles into the SpriteKit tile set for display

### Original Design Changes
**Most of these changes are all additions to the core design based on how our knowledge of the frameworks changed.**
* From Assignment 2 we didn't know that the `GameScene.swift` was a necessary part of storing and displaying game data, so we need to add multiple helper functions, connect to the Game View Controller, and use the Game View Controller to update the model according to proper MVC.
  * This was a necessary change because it allowed us to use specific custom methods such as `tapHandler` and `pressHandler` to interact with the game board. This also required us to use additional helper functions and access the Game View Controller from this location.
  * This change was made in Assignment 3, with some modification for the final project.
* We added a custom emoji Reset button that updated based on how the user was interacting with the game board.
  * This was done because it gave a better user experience. It gives immediate feedback to the user that their actions are being recognized.
  * This was done in Assignment 3 and refined in the final project.
  * The changed code is in the Game Scene and Game View Controller.
* We didn't know how we were going to finally update the stored statistics tracked by the app, so we made small modifications as we went to keep our model up to date.
* We added several getters and setters to clean up our model accessing throughout the Game View Controller.
  * This was because we needed to update the model in the Game Scene at certain points, so to keep MVC integrity we added the getters to return the values.
* We abstracted a few functions that performed similar processes to reduce the amount of code we wrote and streamline our app. 
  * This was mostly in the model with a main example being `checkNeighbors`, which is called by four other functions. We also refactored `populateBoard` to reduce retyped code.

### What we are proud of
We are both extremely proud of the work we put into the design and creation of this app.
There were many problems that we encountered that we were able to overcome through the documentation and lots of Googling. We included many lines of comments in our code discussing what each line is responsible for accomplishing, as well as recording our thought process while building the app. 
#### Louis and TileMap
* Learning how to implement a Tile Map was one of our earliest concerns about our project's viability.
* Louis put in a lot of time figuring out the documentation of SpriteKit in general and CoreGraphics as well.
* Creating the custom assets for the Tile Map was a huge milestone.
* Figuring out the touch handlers was another huge leap forward when we made it work.
#### Harrison and `aoeDig`
* Calling this function in Game View Controller ended up being how all of our game's logic was implemented.
* Most of the game logic was developed in parallel to our understanding of SpriteKit, and our concept of the end product stayed mostly unchanged throughout the development of the app. Creating the most efficient algorithm for solving the unique problems of revealing multiple tiles and detecting the win/loss conditions was one of the highlights of the development process.
#### Brunswick and Debugging in Swift
* Some of our most satisfying moments came late at night after fixing a few nasty bugs. Almost all of the errors were simple in the end, but finding them required a great deal of understanding of our app's core functionality and our plan for the final product. Neither of us were using native machines, and we were both fairly new to Swift as a language. Despite this we were able to overcome our lack of experience and create an app that we both think excels as a software package.
