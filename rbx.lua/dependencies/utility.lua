--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Author: Toxic#2799
Usage: Utility functions that are used in multiple modules.
]]

local utility = {};
local logger = require("./logger");
local api = require("./api");
local json = require("json");

function utility.unique(name)
	return string.format("%s_%s",name,tostring({}):gsub("table: ",""));
end

function utility.readOnly(tbl,name)
	local proxy = {};

	setmetatable(proxy,{
		__index = tbl,
		__newindex = function(t,k,v)
			logger:log(1,"Attempt to update a readonly table.");
		end,
		__metatable = "Protected",
		__tostring = function()
			return string.format("%s: %s",name or "table",tostring(tbl):gsub("table: ",""));
		end,
		__pairs = function(t)
			logger:log(1,"Attempted to use pairs on a class object.")
			return function()
			end
		end
	})
	return proxy;
end

function utility.resolveConfiguration(configuration)
	local default = {
	}

	if(configuration ~= nil) then 
		for key,value in pairs(default) do 
			if(configuration[key] == nil) then 
				configuration[key] = value;
			else 
				if(type(value) == type(configuration[key]) == false) then
					logger:log(1,string.format("Key %q was supposed to be a %q, not a %q.",key,type(value),type(configuration[key])));
					configuration[key] = value;
				end
			end
		end

		return configuration;
	else 
		return default;
	end
end

function utility.resolveToUserId(input)
	local isNumber = function(string)
		local num;
		pcall(function()
			num = tonumber(string)
		end)
		return num ~= nil;
	end

	if(isNumber(input) or type(input) == "number") then 
		local response,body = api.request("GET","https://users.roblox.com/v1/users/"..input,{},{},authentication,false,false);
		if(response.code == 200) then 
			return tonumber(input);
		else 
			logger:log(1,string.format("Invalid userId %q",input));
		end
	else
		local response,body = api.request("GET","https://api.roblox.com/users/get-by-username?username="..input,{},{},authentication,false,false);
		if(response.code == 200) then 
			return json.decode(body)["Id"];
		else
			logger:log(1,string.format("Invalid username %q",input));
			return nil;
		end
	end
end

function utility.resolveToUsername(input)
	local isNumber = function(string)
		local num;
		pcall(function()
			num = tonumber(string)
		end)
		return num ~= nil;
	end

	if(isNumber(input) or type(input) == "number") then 
		local response,body = api.request("GET","https://users.roblox.com/v1/users/"..input,{},{},authentication,false,false);
		if(response.code == 200) then 
			return json.decode(body)["name"];
		else 
			logger:log(1,string.format("Invalid userId %q",input));
		end
	else
		local response,body = api.request("GET","https://api.roblox.com/users/get-by-username?username="..input,{},{},authentication,false,false);
		if(response.code == 200) then 
			return json.decode(body)["Username"];
		else
			logger:log(1,string.format("Invalid username %q",input));
			return nil;
		end
	end
end

return utility;