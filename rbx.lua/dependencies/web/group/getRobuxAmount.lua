local module = {
	authenticationRequired = true;
};

function module.run(authentication,groupId)
	local endpoint = "https://economy.roblox.com/v1/groups/"..groupId.."/currency";
	local response,body = api.request("GET",endpoint,{},{},authentication,false,true);

	if(response.code == 200) then 
		return true,json.decode(body)["robux"];
	else 
		return false,response;
	end
end

return module;