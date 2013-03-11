# l2AnakazelBot
A toolkit of AutoIt scripts to organize [dimensional rift](http://l2.eogamer.com/wiki/Into_the_Dimensional_Rift) Raid boss farming procedure. Uses two launched game windows: Mystic Muse (as far as it has fastest casting speed + Aura skill) - `Main window`, Cardinal - `Support window`.

## TODO
+ Adjustable hotkeys
+ Usage

## Usage
### Client skill panel setup
#### Healer
+ <kbd>F1</kbd> Healing
+ <kbd>F2</kbd> Mana Potion
+ <kbd>F3</kbd> ManaBurn
+ <kbd>F4</kbd> Prayer

#### Mage
+ <kbd>F1</kbd> Aura Flare (or any other magic skill with high casting speed)
+ <kbd>F2</kbd> Mana Potion
+ <kbd>F5</kbd> Change party leader

### Hotkeys
+ <kbd>DEL</kbd> exits Main.au3
+ <kbd>NUMPAD+</kbd> exits Support.au3

### Launching
+ Launch `Main window` and `Support window`
+ Make sure their resolution and position on the screen are the same
+ Capturing `Main window` and `Support window`:
    1. Run `Support.au3` and switch to the game window with your *healer* (as soon as it is captured by the script, it will be deactivated);
    2. Run `Main.au3` and switch to the game window with your *mage* character (this will capture your `main window);
    3. Don't touch anything, the bot is now running (as far as it is *pixelbased*, you can not minimize game window without breaking the work of the script).