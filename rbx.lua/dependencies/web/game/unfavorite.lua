local module = {
    authenticationRequired = true;
};

function module.run(authentication,placeId)
    local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
    local response,body = api.request("GET",endpoint,{},{},authentication);

    if(response.code == 200) then 
        local id = json.decode(body)["UniverseId"];
        local endpoint = "https://games.roblox.com/v1/games/"..id.."/favorites";
        local response,body = api.request("POST",endpoint,{},{isFavorited = false},authentication,true,true);

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