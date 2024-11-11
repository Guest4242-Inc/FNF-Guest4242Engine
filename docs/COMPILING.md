# 🎮 So You Wanna Build Friday Night Funkin' Guest4242 Engine?

0. The Boring (but Essential) Stuff First
    - Grab [Haxe](https://haxe.org) - The cool programming language that makes the beep-boop magic happen
    - Snag [Git](https://www.git-scm.com) - Because we're too fancy for "Download ZIP" (seriously, don't use that button!)
    - Pro tip: Using that ZIP button is like trying to rap without a microphone. Just don't.

1. Time to Get Terminal-ly Cool! 🖥️
    ```
    cd path/to/your/awesome/spot
    ```
    (Like `cd C:\Users\FunkMaster\Documents` if you're feeling fancy)

2. Yoink the Code! 🎵
    ```
    git clone https://github.com/imguest24897-alt/FNF-Guest4242Engine.git
    cd FNF-Guest4242Engine
    ```

3. Get Those Sweet, Sweet Assets 🎵
    ```
    git submodule update --init --recursive
    ```
    (Legal stuff: These assets are more protected than your mom's secret cookie recipe. Check [Funkin.assets LICENSE.md](https://github.com/FunkinCrew/funkin.assets/blob/main/LICENSE.md))

4. Install the Digital Ingredients 🛠️
    ```
    haxelib --global install hmm
    haxelib --global run hmm setup
    hmm install
    haxelib run lime setup
    ```

5. Platform Party Time! 🎉
    - Windows Warriors:
        - Grab those [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
        - Check these boxes like you're ordering pizza toppings:
            - MSVC v143 VS 2022 C++ x64/x86 build tools
            - Windows 10/11 SDK
    - Mac Maestros: Groove to the [lime setup mac guide](https://lime.openfl.org/docs/advanced-setup/macos/)
    - Linux Legends: Rock with the [lime setup linux guide](https://lime.openfl.org/docs/advanced-setup/linux/)
    - HTML5 Heroes: You're already ready! (Lucky you!)

6. For the Native Build Enthusiasts (Optional, but Cool) 😎
    ```
    lime rebuild <platform>
    lime rebuild <platform> -debug
    ```

7. The Grand Finale - Build and Boogie! 🕺
    ```
    lime test <platform>
    ```
    Just swap `<platform>` with your flavor (windows/mac/linux/html5)

## Spicy Build Flags 🌶️

Want to make your build extra special? Here are some magical incantations you can use:

- `-debug`: Unleash the debug beast! Perfect for when you want to see how the sausage is made
    - Includes cool stuff like time travel (PgUp/PgDn in songs)! Use `-DGITHUB_BUILD` if you just want the fun stuff
- `-DFEATURE_POLYMOD_MODS`: For the mod enthusiasts who can't leave well enough alone
- `-DREDIRECT_ASSETS_FOLDER`: Makes asset loading faster than a sugar-rushed boyfriend
- `-DFEATURE_DISCORD_RPC`: Let Discord tell your friends you're busy being funky
- `-DFEATURE_VIDEO_PLAYBACK`: For when still images just aren't enough
- `-DFEATURE_CHART_EDITOR`: Create charts that'll make people's fingers cry
- `-DFEATURE_SCREENSHOTS`: Capture your highest scores (or embarrassing misses)
- `-DFEATURE_STAGE_EDITOR`: For the brave souls who dare to edit stages
- `-DFEATURE_GHOST_TAPPING`: When you want to spam keys like a pianist on coffee

# Help! Something's Wrong! 😱

Before you panic and create a GitHub issue (please don't), check out our [Troubleshooting Guide](TROUBLESHOOTING.md). It's like WebMD for your FNF problems, but actually helpful!
