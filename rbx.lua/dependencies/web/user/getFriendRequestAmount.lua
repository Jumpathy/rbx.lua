

local module = {
	authenticationRequired = true;
};

local resolveToNumber = function(str)
	local existing;
	pcall(function()
		existing = tonumber(str);
	end);
	return existing;
end

function module.run(authentication,callback)
	local endpoint = "https://users.roblox.com/v1/users/authenticated";
	local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
	if(response.code == 200) then 
		if(json.decode(body) ~= nil) then 
			local user = json.decode(body)["id"];
			local endpoint = "https://friends.roblox.com/v1/user/friend-requests/count";

			local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
			if(response.code ~= 200) then 
				logger:log(1,json.encode(json.decode(body)["errors"]));
				return false,response
			else 
				return true,json.decode(body)["count"]
			end
		end
	else
		logger:log(1,"Invalid user cookie!");
	end
end

return module;