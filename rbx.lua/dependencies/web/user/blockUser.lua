local module = {
	authenticationRequired = true;
};

function module.run(authentication,input)
	local run = function(userId)
		if(input ~= nil) then
			local endpoint = "https://www.roblox.com/userblock/blockuser";
			local response,body = api.request("POST",endpoint,{},{blockeeId = userId},authentication,true,true);

            if(response.code == 200) then 
                return true,response;
			else 
                logger:log(1,"Something went wrong.");
                return false,response;
			end
		else
			logger:log(1,"Invalid user");
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;