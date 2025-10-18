# Godot Dungeon Crawler

This is a multiplayer dungeon crawler game built with the Godot Engine. It features procedurally generated levels, AI-powered enemy art, and a variety of loot.

***

## How the Level is Created

The level generation is a multi-step process that creates a unique dungeon every time you play. Here's a breakdown of the algorithms and steps involved:

### 1. Room Generation
* The process starts by scattering a number of rooms of random sizes and shapes (rectangles and circles) across the map.
* If rooms overlap during this process, they are merged into a single larger room, creating more complex and varied shapes.

### 2. Room Connection
* To ensure all rooms are accessible, each room tries to connect with the closest one, creating a tree that will represent the map.

### 3. Depth Calculation and Room Ranking
* Once the rooms are connected, the game calculates the "depth" of each room, which is how far it is from the starting room.
* This depth is then used to assign a "rank" to each room, with rooms farther from the start generally having a higher rank and thus more difficult challenges.

### 4. Assigning Room Types
* Rooms are then assigned special types:
    * **SPAWN:** The starting rooms for the players.
    * **COMBAT:** Rooms filled with enemies to fight.
    * **LOOT:** Rooms that contain weapons and other rewards (not added yet).
    * **EMPTY:** Rooms with no specific purpose, providing a moment of rest.

### 5. Wall Generation
* Finally, the game generates walls around all the rooms and corridors, completing the dungeon layout.

***

## Main Menu and Multiplayer

The main menu allows you to host or join a multiplayer game on your local network.

### Hosting a Game
1.  **Enter a Seed:** You can optionally enter a specific number in the "Seed" text box to generate a predictable dungeon layout. If left empty, a default seed will be used.
2.  **Click Host:** Pressing the "Host" button will start a new server on your local network. Your game will begin broadcasting its availability, allowing others on the same network to see and join your session.
3.  **Start Game:** Once all players have joined, the host can click the "Start" button to begin the game for everyone.

### Joining a Game
1.  **Server Browser:** Any available games hosted on your local network will automatically appear in the server browser on the right side of the screen.
2.  **Join:** Simply click the "Join" button next to the server you want to connect to.
3.  **Wait for Host:** Once you've joined, wait for the host to start the game.

***

## Installation and Setup

Follow these steps to get the game up and running on your local machine.

### Prerequisites:
* **Godot Engine 4.4:** You can download it from the [official Godot website](https://godotengine.org/download/archive/4.4-stable/).
* **Git:** You'll need Git to clone the repository.

### Installation Steps:
1.  **Clone the Repository:**
    Open a terminal or command prompt and run the following command to clone the game's repository to your local machine:
    ```
    git clone [https://github.com/KSaB22/godot-game](https://github.com/KSaB22/godot-game)
    ```
2.  **Set Up the `embedded` Folder:**
    * Inside the cloned repository, create a new folder named `embedded`.
    * Inside the `embedded` folder, create another folder named `bin`.

3.  **Install Stable Diffusion:**
    * Download the **Vulkan** version of Stable Diffusion from the `stable-diffusion.cpp` repository releases. You can find it on [GitHub](https://github.com/leejet/stable-diffusion.cpp/releases).
    * Place the Stable Diffusion executable (`sd.exe`), the DLL (`stable-diffusion.dll`), and other necessary files into the `embedded/bin` folder you created.

4.  **Download the Stable Diffusion Model:**
    * Download the `v1-5-pruned-emaonly.safetensors` model. You can find it on [Hugging Face](https://huggingface.co/stable-diffusion-v1-5/stable-diffusion-v1-5/blob/main/v1-5-pruned-emaonly.safetensors).
    * Place this file directly inside the `embedded/bin` folder.

5.  **Install the LoRA Model:**
    * Inside `embedded/bin`, create a new folder named `loras`.
    * Download the `PixelArtRedmond15V-Pixel-Art-PIXARFK.safetensors` LoRA model from [Hugging Face](https://huggingface.co/artificialguybr/pixelartredmond-1-5v-pixel-art-loras-for-sd-1-5).
    * Place this file inside the `embedded/bin/loras` folder.

6.  **Verify Your Folder Structure:**
    After completing the steps above, your `embedded` folder should look like this:
    ```
    <YourGameProject>/
    |-- embedded/
    |   |-- bin/
    |       |-- sd.exe
    |       |-- stable-diffusion.dll
    |       |-- v1-5-pruned-emaonly.safetensors
    |       |-- loras/
    |           |-- PixelArtRedmond15V-Pixel-Art-PIXARFK.safetensors
    ```
7.  **Open in Godot and Play:**
    * Open the Godot Engine.
    * Click on "Import" and select the game folder from the cloned repository.
    * Once the project is loaded, press the "Play" button (or F5) to run the game.
    * If you wanna run two games on the same PC, click on `Debug -> Customize Run Instances...`, and a new window will open, click on `Enable Multiple Instances` and choose how many just below it.
***

## Controls
* **WASD:** Move
* **E:** Pick up item
* **Mouse:** Aim
* **LMB (Left Mouse Button):** Shoot

***

## How to Play

* **Multiplayer:** This game is designed for multiplayer. You can host a server and have your friends join, or join a server that someone else is hosting (It works only in LAN).
* **Objective:** Explore the procedurally generated dungeons, fight enemies, collect loot and beat your friends.

***
## Gameplay Notes
* **Weapon Skin Generation:** After the level is generated, please wait about **2 minutes** for the weapon skins to be generated by the AI. After this, weapons dropped by enemies will have unique, procedurally generated pixel art skins.

***

## Future Plans

* **Faster AI Generation:** I plan to switch to a more optimized Stable Diffusion model and LoRA to significantly reduce the waiting time for weapon skin generation.
* **Game Rebalancing:** I will be rebalancing the game, including enemy difficulty, weapon stats, and loot drop rates to create a more engaging and fair gameplay experience.
* **Visual Enhancements:** I'll be working on improving the overall visual quality of the game, including updating assets, improving animations, and creating a more cohesive art style.