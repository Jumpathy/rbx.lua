local module = {
	authenticationRequired = true;
};

function module.run(authentication,input)
	local run = function(userId)
		if(userId ~= nil) then
			local endpoint = "https://friends.roblox.com/v1/users/"..userId.."/unfollow";
			local response,body = api.request("POST",endpoint,{{"Content-Length",0}},{},authentication,true,true)
            if(response.code == 200) then 
                return true,response;
			else 
                logger:log(1,"Something went wrong.");
                return false,response;
			end
		else
			logger:log(1,"Invalid user")
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;