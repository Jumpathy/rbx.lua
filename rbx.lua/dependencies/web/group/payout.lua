local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,input,amount)
	local run = function(input)
		if(input ~= nil) then
			local userId = input;
			local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/payouts";
			local response,body = api.request("POST",endpoint,{},{PayoutType = "FixedAmount",Recipients = {{recipientId = userId,recipientType = "User",amount = amount or 1}}},authentication,true,true);
			return response.code == 200,response,json.decode(body)
		else
			logger:log(1,"Invalid user");
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;