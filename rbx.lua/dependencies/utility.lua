local utility = {};

function utility.unique(name)
	return string.format("%s_%s",name,tostring({}):gsub("table: ",""));
end

function utility.readOnly(tbl,name)
	local logger = require("./logger");
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

return utility;