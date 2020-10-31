local module = {
	authenticationRequired = true;
};

function module.run(authentication)
	local endpoint = "https://friends.roblox.com/v1/user/friend-requests/count";
	local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

	if(response.code ~= 200) then 
		logger:log(1,json.encode(json.decode(body)["errors"]));
		return false,response
	else 
		return true,json.decode(body)["count"]
	end
end

return module;