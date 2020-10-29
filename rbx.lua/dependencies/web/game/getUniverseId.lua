local module = {
    authenticationRequired = false;
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

function module.run(authentication,placeId,callback)
    local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
    local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

    if(response.code == 200) then 
        return(json.decode(body)["UniverseId"])
    else
        logger:log(1,"Invalid placeId!");
        return nil;
    end
end

return module;