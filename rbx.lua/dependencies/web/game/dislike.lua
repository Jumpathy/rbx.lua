local module = {
    authenticationRequired = true;
};

function module.run(authentication,placeId)
    local endpoint = "https://www.roblox.com/voting/vote?assetId="..placeId.."&vote=false";
    local response,body = api.request("POST",endpoint,{{"Content-Length",0}},{},authentication,false,true);

    if(response.code == 200) then 
        return true,response;
    else 
        logger:log(1,"Something went wrong.");
        return false,response;
    end
end

return module;