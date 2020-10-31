local module = {
	authenticationRequired = false;
};

function module.run(authentication,groupId,number)
	local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/roles";
	local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
	for _,role in pairs(json.decode(body)["roles"]) do
		if(role.rank == number) then 
			return role.id;
		end
	end
end

return module;