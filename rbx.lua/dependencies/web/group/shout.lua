local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId,message)
	local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/status";
	local response,body = api.request("PATCH",endpoint,{},{message = message or "N/A"},authentication,true,true);
	return response.code==200,response,json.decode(body)
end

return module;