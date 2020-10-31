local module = {
    authenticationRequired = false;
};

function module.run(authentication,placeId)
    local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
    local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

    if(response.code == 200) then 
        return json.decode(body)["UniverseId"];
    else
        logger:log(1,"Invalid placeId!");
    end
end

return module;