# Rbx.lua
**A lua-written Roblox API wrapper.**
## Introduction

[Roblox](https://roblox.com) is an online game platform and game creation system that allows users to program games and play games created by other users. 
They have a documented [REST API](https://devforum.roblox.com/t/document-all-roblox-api-sites-on-the-developer-hub/154714) that allows developers to create functions to their needs.

Rbx.lua is a Lua wrapper for the official Roblox API, directly inspired by [Noblox.js](https://github.com/suufi/noblox.js). It allows you to do things you would normally do on Roblox through a simple object oriented system. Lua itself is beginner-friendly, but powerful in the hands of someone who knows what they're doing. It's expandability makes it as capable as the other competitors such as JavaScript, Python, Node, etc. Rbx.lua is also cross-compatible with [Discordia](https://github.com/SinisterRectus/Discordia) which allows you to make Lua-based discord bots that can have integrated Roblox support.

You will require some basic programming experience to begin with this system, but once you get the hang of it, it should be second nature to you!

## Requirements
- [**Luvit**](https://luvit.io/install.html)

## Community (or support if required)
- [**Discord server**](https://discord.gg/5ssrpQc)

## Installation
- Install [**Luvit**](https://luvit.io/install.html) with the instructions specified for your platform.
- To install this, simply run `lit install iiToxicity/rbx.lua`
- Run your code by using for example, `luvit code.lua`

## Example
```lua
local roblox = require("rbx.lua");

roblox.newFromCookie("ROBLOSECURITY HERE",function(success,client)
    if(success) then 
        client.functions.resolveToUsername(client.userId,function(username)
            print(username,"authorized");
        end)
    end
end)
```
