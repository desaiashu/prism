Ghost
=====

The Ghost Template is a starting point for Turn Based Multiplayer games built with the [mgwuSDK](https://github.com/adesai/mgwuSDK). You should check out the Turn Based Multiplayer section of the [mgwuSDK Instructions](https://s3.amazonaws.com/mgwu/mgwuSDK-instructions.html) for info on how the Turn Based multiplayer system works to help you build your own game.

Ghost is available for free on the app store, you can find it [here](http://mgw.us/ghost/2)!

(note: The mgwuSDK can be used freely for development, but for use in a production app the game has to be published through [MakeGamesWithUs](https://www.makegameswith.us). For more info or questions, contact [publish@makegameswith.us](mailto:publish@makegameswith.us))

**If you have any questions/comments/feature requests, email ashu@makegameswith.us**

Table of Contents
-----------------

1. General Info
2. Cocos2D Template
3. Kobold2D Template
4. Interface Builder Template
5. License

1. General Info
---------------

The Ghost template is designed to be a starting point for Turn Based Multiplayer games like Words With Friends and Draw Something. For all the server/backend needs, we rely on the mgwuSDK.

The menu structure for most of these games is common, while the gameplay itself is game specific. The core components of this game are: 

**Main menu and tutorial:** 

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/menu.png)

**A list of current games:**

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/games.png)

**A list of players to begin a new game with:**

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/players.png)

**A list of friends to invite to the game:**

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/invite.png)

**The gameplay itself:**

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/game.png)

**Chat between players:**

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/ghost/chat.png)

2. Cocos2D Template
-------------------
Cocos2D-Ghost is a cocos2d (v2.0+) version of Ghost. Some UIKit elements are used in CCGhost when needed.

**Structure and Customization**

All classes are subclasses of StyledCCLayer. StyledCCLayer contains helper methods for setting up UI elements. The StyledCCLayer contains methods for creating the navigation bar (at the top), setting up background iamges, and adding buttons.

The StartLayer is the main menu. You will replace this layer with your own menu. The TutorialLayer is an example and will also be replaced with your own tutorial system.

The StartLayer transitions into the "Games" screen (according to the title at the top of the screen) with a tab menu at the bottom. 
This screen is composed of two layers:

1. An InterfaceLayer is placed on top, and contains the navigation menu at the top and the tab menu. The InterfaceLayer controls all the UI navigation elements.

2. Under the InterfaceLayer is a table layer. The first table layer that is shown is "GamesTableLayer." This layer is swapped out for other layers like "PlayersTableLayer" and "InviteTableLayer." The tab menu controls which table layer is shown. Each table layer is a subclass of TableLayer. TableLayer contains methods for setting up tables. The method "populateArray" is where you will customize what is displayed in each item in the table. In GamesTableLayer, items would be games that are pending or completed. In PlayersTableLayer, items would be people to play with. In InviteTableLayer, items would be Facebook friends to invite to play.

When a row in one of the table layers is pressed, a GameLayer scene is pushed onto CCDirector (pushed onto the stack of scenes). You will replace GameLayer with your own game. GuessLayer, PopupLayer, and DefinitionViewController are both called from GameLayer and are game-specific.

DefinitionViewController is a UIKit element. Look at it and the "define" method of GameLayer to see how to integrate a UIKit view controller with cocos2d. Look at the init method of InviteTableLayer and ChatLayer to see how to integrate a UIKit element with cocos2d.


**Advanced Notes**

* BadgedCCMenuItemSprite is a subclass of CCMenuItemSprite that is used for the tab menu. It allows for red badges to appear as notifications. See InterfaceLayer for examples.

* CCDirector+PopTransition is a category (a universally applied and automatic subclass, essentially) on CCDirector that allows for transitions when a scene is popped off the stack. See the "back" method of ChatLayer to see an example.

* CCMenuTouchSwallow is a subclass of CCMenu that does not swallow touches. Normally, a touch on a CCMenu is canceled so that no other game elements can detect that touch. All table layer cells use CCMenuTouchSwallow because the table needs to detect touches in order for scrolling to work.

* ProfilePictureCache (and its category, ProfilePictureCache+) asynchronously sets the Facebook profile pictures that you see in the tables.

* SWTableLayer is the underlying implementation of the Tables.

* CCControlButton is the underlying implementation of the buttons.

**Special Thanks**

Thanks to Sangwoo Im and Dean Morris (SWTable), Ori and Princeton University (Lexicontext), and Yonnick Loriot (CCControl classes).

3. Kobold2D Template
--------------------
Kobold2D-Ghost is a Kobold2D (v2.0+) template of Ghost. Move the Kobold2D-Ghost folder into:

/path/to/__Kobold2D__/templates/project/

The template will allow you to create a Ghost project from the Kobold2D project starter.

**See above for info on the Cocos2D Template, the project structure is described there.**

4. Interface Builder Template
-----------------------------

**Menu Structure**

The Interface Builder Template uses a Storyboard to layout all the views. The root view controller is the NavigationController containing the MenuViewController. When you hit play, the TabBarController is pushed on the stack, with 3 tabs for GamesViewController, PlayersViewController and InviteViewController. When you engage in a game through any of these 3 tabs, the GameViewController (different from GamesViewController) is pushed on the stack. If you tap on the chat button, the ChatViewController is pushed on the stack. (See the above screenshots).

**Visual Customization**

Most of the visual customization is done in the storyboard, however, some things are done in code. All buttons are instances of StyledButton, which customizes their look. Some labels are instances of NexaLabel or GhostyLabel. All cells are instances of TableViewCell, to customize appearance. The navigation bar and tab bar are customized in their respective classes (and have different height than standard), they make heavy use of the new iOS Appearance APIs.

**Misc Classes**

SearchDisplayController is the search bar in the InviteViewControler. Guess/Popup/DefinitionViewController are game specific views. ProfilePictureCache loads profile pictures asynchronously from Facebook. PullRefresh is a pull to refresh element for the table views. DTCustomColoredAccessory is used to change the color of the arrow on table view cells.

**Special Thanks**

Thanks to Leah Culver (PullRefresh), Cocoanetics.com (DTCustomColoredAccessory), Ori and Princeton University (Lexicontext).

5. License
----------

**Our own made up license:**  
(because I looked at a bunch of licenses and the best one I found was [this](http://en.wikipedia.org/wiki/Beerware))

You're welcome to use any and all the code from the Ghost templates to do whatever you would like, as long as it isn't evil.

However, in order to use the mgwuSDK in production applications you need to publish your game through MakeGamesWithUs, so without that, the template might not be terribly useful. But you should absolutely publish through us, we do all the art and music for your games, and will help it shine on the app store! Plus with our SDK you will cut development time by around 3x, and you can make 3 games instead of just making 1! Since we take a 30% cut, that means the expected value for you is 2.1 games instead of the one game you could've made in that time. You do the math.