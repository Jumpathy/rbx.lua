local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,input,callback)
	local run = function(input)
		if(input ~= nil) then
			local userId = input;
			local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/join-requests/users/"..userId;
			local response,body = api.request("POST",endpoint,{{"Content-Length",0}},{},authentication,false,true);
			return response.code==200,response,json.decode(body)
		else
			logger:log(1,"Invalid user");
		end
	end

	return run(utility.resolveToUserId(input));
end

return module;