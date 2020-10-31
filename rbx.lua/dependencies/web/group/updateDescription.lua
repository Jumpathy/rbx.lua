local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,description)
	local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/description";
	local response,body = api.request("PATCH",endpoint,{},{description = description or "N/A"},authentication,true,true);
	return response.code==200,response,json.decode(body)
end

return module;