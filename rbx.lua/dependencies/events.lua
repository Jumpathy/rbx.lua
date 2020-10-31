--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Author: Toxic#2799
Usage: Events that can be registered with callbacks for the client.
]]

local events = {};
local class = require("./class");
local logger = require("./logger");

local global = _G;
local connections;
if(global.eventConnections_RBX ~= nil) then 
	connections = global.eventConnections_RBX;
else
	internal = {};
	connections = {};

	global.internal_RBX = internal;
	global.eventConnections_RBX = connections;
	global.onEmitted = function(name,callback,...)
		table.insert(global.internal_RBX,{name,callback,unpack(...)})
		if(global["event_"..name] ~= nil) then 
			global["event_"..name](...);
		end
	end

	global.emit = function(name,...)
		local arguments = {...};

		for _,details in pairs(global.internal_RBX) do 
			if(details[1] == name) then 
				if(#details == 3) then
					if(details[3] == arguments[3]) then
						details[2](...);
					end
				else 
					details[2](...);
				end
			end
		end
	end
end 

events.onEmitted = global.onEmitted;
events.emit = global.emit;

function events.new(name,callback)
	if(connections[name] == nil) then
		local methods = {
			["callback"] = callback;
		};

		local event = class.new("Event",methods);
		connections[name] = event;
		
		return event;
	else	
		logger:log(1,string.format("Event %q already exists!",tostring(name)))
		return nil;
	end
end

function events.invoke(name,...)
	if(connections[name] ~= nil) then 
		events.emit(name,...);
		return connections[name]["callback"](...);
	else 
		logger:log(1,string.format("Event %q does not exist!",tostring(name)))
	end
end

return events;