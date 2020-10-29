local module = {};

local resolveToNumber = function(str)
	local existing;
	pcall(function()
		existing = tonumber(str);
	end);
	return existing;
end

function module.run(authentication,input,callback)
    if(resolveToNumber(input) ~= nil or type(input) == "number") then 
        if(type(input) == "number" or resolveToNumber(input) ~= nil) then
            local response,body = api.request("GET","https://users.roblox.com/v1/users/"..input,{},{},authentication,false,false)
            if(response.code == 200) then 
                if(json.decode(body)["name"] == nil) then 
                    logger:log(1,"Invalid userId (user doesn't exist)");
                else
                    return json.decode(body)["name"];
                end
            end
        else
            logger:log(1,"Invalid userId (user doesn't exist)");
        end
    else
        local response,body = api.request("GET","https://api.roblox.com/users/get-by-username?username="..input,{},{},authentication)
            
		if(response.code == 200) then 
            input = json.decode(body)["Id"];
            if(type(input) == "number" or resolveToNumber(input) ~= nil) then
                local response,body = api.request("GET","https://users.roblox.com/v1/users/"..input,{},{},authentication,false,false)
                if(response.code == 200) then 
                    if(json.decode(body)["name"] == nil) then 
                        logger:log(1,"Invalid userId (user doesn't exist)");
                    else
                        return json.decode(body)["name"];
                    end
                end
            else
                logger:log(1,"Invalid userId (user doesn't exist)");
            end
        else
            logger:log(1,"Invalid username provided.") 
        end
    end 
end

return module;