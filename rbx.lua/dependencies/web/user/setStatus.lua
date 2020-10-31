local module = {
	authenticationRequired = true;
};

function module.run(authentication,status)
	if(status ~= nil) then 
		local response,body = api.request("GET","https://users.roblox.com/v1/users/authenticated",{},{},authentication,true,true);
		if(response.code == 200) then 
			if(json.decode(body) ~= nil) then 
				local user = json.decode(body)["id"];
                local endpoint = string.format("https://users.roblox.com/v1/users/%s/status",user);
				local response,body = api.request("PATCH",endpoint,{},{status = status},authentication,true,true);
				return response.code == 200,response
			end
		else
			logger:log(1,"Invalid user cookie!");
		end
	else
		logger:log(1,"Please provide a valid status!");
	end
end

return module;