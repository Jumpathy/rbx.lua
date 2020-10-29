local module = {};

local resolveToNumber = function(str)
	local existing;
	pcall(function()
		existing = tonumber(str);
	end);
	return existing;
end

function module.run(authentication,input)
    if(resolveToNumber(input) ~= nil or type(input) == "number") then 
        local response,body = api.request("GET","https://users.roblox.com/v1/users/"..tostring(input):sub(1,25),{},nil,authentication,false,true);

        if(response.code == 200) then 
            return json.decode(body)["id"];
        else 
            logger:log(1,"Invalid userId (user doesn't exist)");
        end
    else
        local response,body = api.request("GET","https://api.roblox.com/users/get-by-username?username="..input,{},nil,authentication,false,true);

        if(response.code == 200) then 
            input = json.decode(body)["Id"];
            if(type(input) == "number" or resolveToNumber(input) ~= nil) then
                return input;
            else
                logger:log(1,"Invalid userId (user doesn't exist)");
                return nil;
            end
        else
            logger:log(1,"Invalid username provided.") 
            return nil;
        end
    end 
end

return module;