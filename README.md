MGWU Ghost Template
===================

This template serves as a starting point for turn based multiplayer games. If you'd like to use Kobold2D/Cocos2d instead, use [this version of the template](https://s3.amazonaws.com/mgwu/_MGWU-Multiplayer-Template_.zip). The game is even [available on the appstore](www.mgw.us/ghost/).

You should familiarize yourself with the Turn Based Multiplayer section of the [mgwuSDK Instructions](https://s3.amazonaws.com/mgwu/mgwuSDK-instructions.html) for info on how the Turn Based multiplayer system works to help you build your own game.

**If you have any questions/comments/feature requests, email ashu@makegameswith.us**

Table of Contents
-----------------

1. Setup
2. General Info
3. Project Structure
4. How to Plug in Your Game
5. License


1. Setup
--------

Important note: if you create 2 copies of the ghost project and build them both on the simulator, the simulator will likely black screen and not run your project. If this happens, in the simulator top bar go to iOS Simulator -> Reset Content and Settings...

The template is set up to run the game ghost, when you start developing your own game you need to make some changes to make sure our servers + facebook treat it as a new app.

**Enabling SDK Features**

First create your app on our server at this url: [https://dev.makegameswith.us/createapp](https://dev.makegameswith.us/createapp)

In the left bar of Xcode, click on your project, then navigate to "info" (see screenshot below). Change the Bundle identifier to "com.xxx.xxx" to match the app you created on the server. **Delete the project from any simulator / device you've been testing on, you'll also need to delete any other apps which use the new bundle identifier (to ensure this, in the simulator top bar you can go to iOS Simulator -> Reset Content and Settings...)**. On the top bar of Xcode go to Product -> Clean. This should ensure you are using the new bundle identifier.

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/bundle.png)

Now open the file AppDelegate.m. In the method initializationComplete (**or if you're not using Kobold2d**, in application: didFinishLaunchingWithOptions:) find the line:

<!--hfmd>.. sourcecode:: objective-c<hfmd-->

    [MGWU loadMGWU:@"secretkey"];

Replace 'secretkey' with the secret key you used when you created your app on the server. 

**Enabling Facebook Features**

Facebook integration is set up for you in this template, but you'll have to create a new Facebook app. Follow these steps (here's a link to the [Facebook App Dashboard](https://developers.facebook.com/apps/), you'll need to register as a developer):

![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/facebook1.png)
![image](https://s3.amazonaws.com/mgwu-misc/mgwuSDK+Tutorial/facebook2.png)


2. General Info
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


3. Project Structure
--------------------

**Menu Structure**
The Interface Builder Template uses a Storyboard to layout all the views. The root view controller is the NavigationController containing the MenuViewController. When you hit play, the TabBarController is pushed on the stack, with 3 tabs for GamesViewController, PlayersViewController and InviteViewController. When you engage in a game through any of these 3 tabs, the GameViewController (different from GamesViewController) is pushed on the stack. If you tap on the chat button, the ChatViewController is pushed on the stack. (See the above screenshots).

**Visual Customization**

Most of the visual customization is done in the storyboard, however, some things are done in code. All buttons are instances of StyledButton, which customizes their look. Some labels are instances of NexaLabel or GhostyLabel. All cells are instances of TableViewCell, to customize appearance. The navigation bar and tab bar are customized in their respective classes (and have different height than standard), they make heavy use of the new iOS Appearance APIs.

**Misc Classes**

SearchDisplayController is the search bar in the InviteViewControler. Guess/Popup/DefinitionViewController are game specific views. ProfilePictureCache loads profile pictures asynchronously from Facebook. PullRefresh is a pull to refresh element for the table views. DTCustomColoredAccessory is used to change the color of the arrow on table view cells.


4. How to Plug in Your Game
---------------------------

Generally it's best to build the basic components of the game in a different project, this way you don't have to go through all the menus when you want to test things. Then once you've tested things to mostly work the way you want with dummy data, work on plugging this back into the template.

**What's going on:**

GameViewController:  
If the user is creating a new game, the GameViewController's game object is set to nil. If the user is continuing/viewing an existing game, the GameViewController's game object is set to that game. When you press play, the GuessViewController is created, variables in the GuessViewController are set, it is pushed as a scene.

GuessViewController:  
GuessViewController is passed relevant info from the GameViewController when it is created
GuessViewController contains the actual gameplay
Once the gameplay is finished, the guessed method is called on the delegate (which is the original GameViewController)

Back to GameViewController:  
The guessed method in the GameViewController is called once the guess has been made. Based on the guess the result of the move is completed and sent up to the server.

**What you need to do:**

GameViewController:  
Customize the storyboard + init + viewDidLoad methods to include all the UI elements you want. Customize the loadGame method to show the UI elements you want based on the state of the game (if it is a new game / if it is your turn / if it is your opponents turn / if the game is over), look through the existing code to understand how this is done. Customize the prepareForSegue method to set up variables you need in the GuessViewController. Learn what a delegate is. Look at the GuessDelegate (defined in GuessViewController.h). Customize the guessed method parameters (in GuessViewController.h and GameViewController.m) to pass whatever values you want from the GuessViewController back to the GameViewController. Customize the guessed method to take in info from the GuessViewController and make a call to "[MGWU move:…", make sure the callback for the move call is @selector(moveCompleted:)

GuessViewController:  
Customize the variables in the GuessViewController to allow the GameViewController to pass in whatever you want. Build your game into the GuessViewController, but make sure you maintain everything you need for the delegate (again be sure to learn what this is). When the game is over, make sure you call [delegate guessed:] and pass through any info you want on the game.

This should be enough to carry you forward, poking around the code / re-reading the SDK instructions should help explain the rest!


5. License
----------

**Our own made up license:**  
(because I looked at a bunch of licenses and the best one I found was [this](http://en.wikipedia.org/wiki/Beerware))

You're welcome to use any and all the code from the Ghost templates to do whatever you would like, as long as it isn't evil.

However, in order to use the mgwuSDK in production applications you need to publish your game through MakeGamesWithUs, so without that, the template might not be terribly useful. But you should absolutely publish through us, we do all the art and music for your games, and will help it shine on the app store! Plus with our SDK you will cut development time by around 3x, and you can make 3 games instead of just making 1! Since we take a 30% cut, that means the expected value for you is 2.1 games instead of the one game you could've made in that time. You do the math.

**Special Thanks**

Thanks to Leah Culver (PullRefresh), Cocoanetics.com (DTCustomColoredAccessory), Ori and Princeton University (Lexicontext).