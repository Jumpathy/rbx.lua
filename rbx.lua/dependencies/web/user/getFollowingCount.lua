local module = {
	authenticationRequired = false;
};

local resolveToNumber = function(str)
	local existing;
	pcall(function()
		existing = tonumber(str);
	end);
	return existing;
end

copyTable = function(tbl)
	local copy = {};
	for k,v in pairs(tbl) do 
		if(type(v) == "table") then 
			copyTable(v);
		else 
			copy[k] = v;
		end
	end
	return copy;                
end 

function module.run(authentication,userId,callback)
	local run = function(userId)
		if(type(userId) == "number" or resolveToNumber(userId) ~= nil) then
			local endpoint = "https://friends.roblox.com/v1/users/"..userId.."/followings/count";
			local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
			if(response.code == 200) then 
				return (json.decode(body)["count"])
			else 
				logger:log(1,"Invalid user!");
			end
		else
			logger:log(1,"Invalid int provided for `userId`")
		end
	end

	if(resolveToNumber(userId) ~= nil or type(userId) == "number") then 
		return run(userId);
	else
		local endpoint = "https://api.roblox.com/users/get-by-username?username="..userId;
		local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
		if(response.code == 200) then 
			return run(json.decode(body)["Id"]);
		else
			logger:log(1,"Invalid username provided.") 
		end
	end 
end

return module;