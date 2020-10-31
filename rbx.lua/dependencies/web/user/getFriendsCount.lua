local module = {
	authenticationRequired = false;
};

function module.run(authentication,userId,callback)
	local run = function(userId)
		if(userId ~= nil) then
			local endpoint = "https://friends.roblox.com/v1/users/"..userId.."/friends/count";
			local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

			if(response.code == 200) then 
				return json.decode(body)["count"];
			else 
				logger:log(1,"Invalid user!");
			end
		else
			logger:log(1,"Invalid int provided for `userId`")
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;