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