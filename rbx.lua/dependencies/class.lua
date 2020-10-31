--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Author: Toxic#2799
Usage: Creating readonly custom class objects.
]]

local class = {};
local utility = require("./utility");

function class.new(name,methods)
	local object = {};

	for key,method in pairs(methods) do 
		object[key] = method;
	end

	return utility.readOnly(object);
end

return class;