
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

function module.run(authentication,groupId,input,callback)
	local run = function(input)
		if(type(input) == "number" or resolveToNumber(input) ~= nil) then
			local userId = input;
			local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/join-requests/users/"..userId;
			local response,body = api.request("POST",endpoint,{
                {"Content-Length",0}
            },{},authentication,false,true);
			return response.code==200,response,json.decode(body)
		else
			logger:log(1,"Invalid userId (user doesn't exist)");
		end
	end

	if(resolveToNumber(input) ~= nil or type(input) == "number") then 
		return run(input);
	else
		local response,body = api.request("GET","https://api.roblox.com/users/get-by-username?username="..input,{},{},authentication,false,false);
		if(response.code == 200) then 
			return run(json.decode(body)["Id"]);
		else
			logger:log(1,"Invalid username provided.") 
		end
	end 
end

return module;