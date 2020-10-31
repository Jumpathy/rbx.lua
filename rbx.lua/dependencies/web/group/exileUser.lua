local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,input)
	local run = function(input)
		if(input ~= nil) then
			local userId = input;
			local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/users/"..userId;
			local response,body = api.request("DELETE",endpoint,{},{},authentication,false,true);
			return response.code == 200,response,json.decode(body)
		else
			logger:log(1,"Invalid userId (user doesn't exist)");
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;