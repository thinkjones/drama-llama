# Camp Drama Llama: Overview
This is a repo for a three hour workshop for kids where we teach them computer fundamentals and AI.
Each folder in the root contains an activity for the kids and I need Claude Code's help setting the repo up for their activity.

See `wks2-slides.pptx` for the slides used in this workshop.

## Activities
### Activity 1: Files and Folders
Folder Name: twlightsparkle

Task for kids: Using the terminal try to find a file called activity2.txt.

Claude Code:
* Create a folder structure 5 folders deep with random pony, barbie and dragon zee ball names.
* In all leaf nodes place a file called "dead-end" except one leaf node which has a file called activity2.txt.
* Create a cheatsheet telling them:
	* 1. How to load the terminal on windows (wsl)
	* 2. How to use basic file / folder navigation and navigating to the home folder. Assume this repo will get synced to `~/drama-llama/`. How to view a file in the terminal.

### Activity 2: Welcome to Python
Folder Name: gohon

Task for kids:
* Load up Claude Code and ask Claude to "Write a simple Python program called agent_welcome.py that asks for the user's agent name and prints a cool welcome message with ASCII art."
* Do it in `gohan` dir.
* Ask them to customize the ASCII art.

Claude Code:
* Create a cheatsheet telling them:
	* Which folder to navigate to.
	* How to load Claude Code.
	* How to open a text editor to view the files. Use Zed?

### Activity 3: Minecraft Mod
Folder Name: `steve`

Task for kids:
* Use Claude Code to alter a foundation Minecraft Forge mod.
* Discover what you can do and make an alteration.

Claude Code:
* Create a simple Minecraft Forge mod template for 1.20.1 that adds a custom armor set called AgentArmor. Include placeholder texture files and build instructions.
* Create a cheetsheet telling the kids how to build on this.
* Create Claude and Agent files with necessary skills needed to implement this.

## Teacher Prep
* Create a shell script and or readme guide which will prep each computer so it has:
	* WSL Setup
	* This repo downloaded.
	* Any required applications installed.
