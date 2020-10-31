local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,input,position)
	local run = function(input)
		if(input ~= nil) then
			local userId = input;
			local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/users/"..userId;
			local response,body = api.request("PATCH",endpoint,{},{roleId = client.group.getRoleId(groupId,position);},authentication,true,true);
			return response.code == 200,response,json.decode(body)
		else
			logger:log(1,"Invalid user");
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;