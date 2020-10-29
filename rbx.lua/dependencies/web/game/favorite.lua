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

copyTable = function(tbl)
    local copy = {};
    for k,v in pairs(tbl) do 
        if(type(v) == "table") then 
            copyTable(v);
        else 
            copy[k] = v;
        end
    end
    return copy;                
end 

function module.run(authentication,placeId)
    local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
    local response,body = api.request("GET",endpoint,{},{},authentication);

    if(response.code == 200) then 
        local id = json.decode(body)["UniverseId"];
        local endpoint = "https://games.roblox.com/v1/games/"..id.."/favorites";
        local response,body = api.request("POST",endpoint,{},{ isFavorited = true; },authentication,true,true);

        if(response.code == 200) then 
            return true,response;
        else 
            logger:log(1,"Something went wrong.");
            return false,response;
        end
    else
        logger:log(1,"Invalid placeId!");
    end
end

return module;