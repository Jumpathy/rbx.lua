local module = {
	authenticationRequired = false;
};

function module.run(authentication,input)
	local run = function(userId)
		if(userId ~= nil) then
			local endpoint = "https://friends.roblox.com/v1/users/"..userId.."/friends";
			local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
			
			if(response.code == 200) then
				return true,json.decode(body)["data"]
			else 
				logger:log(1,"Something went wrong.");
				return false,response 
			end
		else
			logger:log(1,"Invalid int provided for `userId`")
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;