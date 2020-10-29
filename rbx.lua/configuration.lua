--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

This contains configuration options for rbx.lua if needed. If you don't know what you're doing, don't modify them. 
I plan on adding more configuration later, but this is the start.
--]]

return {
	shortPollDelay = 10000, --> MS (short poll is stuff like on group shout, it tends to throw a 429 error if you go any sooner than this.)
}