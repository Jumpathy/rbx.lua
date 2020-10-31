local module = {
	authenticationRequired = true;
};

function module.run(authentication,callback)
	local run = function(userId)
		if(userId ~= nil) then
			local endpoint = "https://friends.roblox.com/v1/users/"..userId.."/friends/online";
			local response,body = api.request("GET",endpoint,{},{},authentication,true,true);
			if(response.code == 200) then 
				return true,json.decode(body)["data"]
			else 
				logger:log(1,"Something went wrong.");
				return false,response
			end
		else
			logger:log(1,"Invalid user");
		end
	end

	return run(client.userId);
end

return module;