# A Few Server Utilities

[![Linting Status](https://img.shields.io/github/workflow/status/TwistedTail/A-Few-Server-Utilities/GLuaFixer?label=Linter%20Status)](https://github.com/TwistedTail/A-Few-Server-Utilities/actions?query=workflow%3AGLuaFixer)
[![Repository Size](https://img.shields.io/github/repo-size/TwistedTail/A-Few-Server-Utilities?label=Repository%20Size)](https://github.com/TwistedTail/A-Few-Server-Utilities)

## What's this?
This is an addon for [Garry's Mod](https://garrysmod.com), which adds a set of functions that could be useful for most, if not all, server owners.

## What does it add? How do I use it?
Note: All the utilities included on this addon are **ON** by default. The state of these functionalities will persist between restarts, and it's not necessary to add the ConVars related to these to your `server.cfg` file. The commands listed below can be only used by a superadmin or directly from the server console. 

### Automatized server restart
Keeping servers up on the same map for too long is [not recommended](https://wiki.garrysmod.com/page/Global/CurTime), so this handy utility will do it for you every 6 hours (`AFSU.FirstRestartDelay`) if nobody joined, or 5 minutes (`AFSU.RestartDelay`) after the last player left the server.
- This utility can be toggled with the console command `afsu toggle restart_server`.

### Hostname randomizer
Whether you want to add a random message to your server name or you want to randomize it entirely, this functionality is just for you. If there's at least one server name or message stored on your data folder (`AFSU.DataPath`), your hostname will change every 15 seconds (`AFSU.HostNameDelay`) with any of the values from the list.
- The randomized hostname will follow the structure `[Server name] - [Server message]`.
- This utility can be toggled with the console command `afsu toggle change_hostname`.
- New server names can be added using the command `afsu add server_name`. This will be added directly to the list and saved to a JSON file backup inside the data folder (`AFSU.NamesFile`). You can also see the list of all the existing server names by using the command `afsu list server_name`.
- New server messages can be added using the command `afsu add server_message`. This will be added directly to the list and saved to a JSON file backup inside the data folder (`AFSU.MessagesFile`). You can also see the list of all the existing server messages by using the command `afsu list server_message`.

### Loading screen randomizer
Same idea as the previous one, except with your loading screen. If there's at least one loading screen link stored on your data folder, this will change every 60 seconds (`AFSU.LoadScreenDelay`).
- This utility can be toggled with the console command `afsu toggle change_loading_screen`.
- New loading screen URLs can be added using the command `afsu add loading_screen`. This will be added directly to the list and saved to a JSON file backup inside the data folder (`AFSU.LoadingScreenFile`). You can also see the list of all the existing loading screen URLs by using the command `afsu list loading_screen`.

### Spawned entity freezing
Incredibly, it's a fairly effective way to prevent server crashes by just spamming props since these will be frozen instantly. It can give your staff some seconds to react to this behavior. It currently covers props, SENTs, vehicles and ragdolls.
- This utility can be toggled with the console command `afsu toggle freeze_ents`.

### Steam Family Share prevention
Meant for those servers that are having issues with players rejoining under family shared accounts to evade bans, this feature will promptly get rid of them as soon as they're done loading.
- This utility is toggled `off` by the default and can be enabled with the console command `afsu toggle allow_family_share`.

## How to install this?

### The recommended way
Clone this repository with the SSH `git@github.com:TwistedTail/A-Few-Server-Utilities.git` into your server's addon folder. You can use a Git client, such as [GitKraken](https://www.gitkraken.com/) or [Github Desktop](https://desktop.github.com/), or just [Git Bash](https://git-scm.com/downloads) if GUIs are not your thing.

### The not recommended way
If you don't care about keeping your server addons updated, you can always [download the addon as a .zip file](https://github.com/TwistedTail/A-Few-Server-Utilities/archive/master.zip) and decompress it inside your addons folder. Don't forget to make sure the folder is placed correctly; if you open it, there should be multiple files and one folder instead of a single folder with the name of the addon (move this folder to your server's addon folder if that's the case and delete the empty one).

## To-Do list
- [x] Fix ragdoll unfreezing.
- [ ] Add remove/delete commands.
- [ ] Add update/replace commands.
- [ ] Add chat command support.
- [ ] Add in-game menu to control all the registered utilities.
- [ ] Simplify command creation.
- [ ] Document the code.