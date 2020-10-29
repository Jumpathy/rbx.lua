local module = {
	authenticationRequired = true;
};

local resolveToNumber = function(str)
	local existing;
	pcall(function()
		existing = tonumber(str);
	end);
	return existing;
end

function module.run(authentication,status,callback)
	if(status ~= nil) then 
		local response,body = api.request("GET","https://users.roblox.com/v1/users/authenticated",{},{},authentication,true,true);
		if(response.code == 200) then 
			if(json.decode(body) ~= nil) then 
				local user = json.decode(body)["id"];
                local endpoint = string.format("https://users.roblox.com/v1/users/%s/status",user);

				local response,body = api.request("PATCH",endpoint,{},{
					status = status
				},authentication,true,true);
				if(response.code ~= 200) then 
					logger:log(1,json.encode(json.decode(body)["errors"]));
				end

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