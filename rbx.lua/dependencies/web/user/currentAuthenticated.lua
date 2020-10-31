local module = {
    authenticationRequired = true;
};

function module.run(authentication)
    local endpoint = "https://users.roblox.com/v1/users/authenticated"
    local response,body = api.request("GET",endpoint,{},{},authentication,false,true);

    if(response.code == 200) then 
        return json.decode(body);
    else
        logger:log(1,"Invalid user cookie!");
    end
end

return module;