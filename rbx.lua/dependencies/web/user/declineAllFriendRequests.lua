local module = {
	authenticationRequired = true;
};

function module.run(authentication)
	local endpoint = "https://friends.roblox.com/v1/user/friend-requests/decline-all";
	local response,body = api.request("POST",endpoint,{{"Content-Length",0}},{},authentication,true,true);

	if(response.code == 200) then 
		return true,response;
	else 
		logger:log(1,"Something went wrong.");
        return false,response;
	end
end

return module;