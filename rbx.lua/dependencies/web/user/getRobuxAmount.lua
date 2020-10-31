local module = {
	authenticationRequired = true;
};

function module.run(authentication,transactionType)
	local endpoint = "https://economy.roblox.com/v1/users/"..client.userId.."/currency";
	local response,body = api.request("GET",endpoint,{},{},authentication,false,true);
	
	if(response.code == 200) then 
		return json.decode(body)["robux"];
	else 
		return 0;
	end
end

return module;