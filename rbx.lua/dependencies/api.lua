local json = require("json");
local coro = require("coro-http");
local logger = require("./logger");
local timer = require("timer");
local api = {};

function api.findHeader(response,name)
    for _,header in pairs(response) do 
        if(header[1] == name) then 
            return header[2];
        end
    end
end 

function api.request(method,endpoint,headers,body,authentication,jsonEncode,getXCSRF)
    headers = headers or {};
    body = body or {};
    
    local c = 0;
    for _,k in pairs(body) do 
        c = c + 1;
    end
    if(c == 0) then 
        body = nil;
    end

    if(authentication ~= nil) then 
        table.insert(headers,{"Cookie",".ROBLOSECURITY="..authentication});
        if(getXCSRF == true) then
            table.insert(headers,{"X-CSRF-TOKEN",api.getXCSRF(authentication)});
        end
    end

    if(jsonEncode) then 
        table.insert(headers,{"Content-Type","application/json"});
        if(body ~= nil) then
            body = json.encode(body);
        end
    end

    return coro.request(method,endpoint,headers,body);
end

function api.getXCSRF(authentication)
    local headers = {
        {"Content-Length",0};
        {"X-CSRF-TOKEN",nil};
    };

    local response,body = api.request("POST","https://auth.roblox.com/v2/logout",headers,{},authentication,true,false);
    if(response.code ~= 200) then
        if(response.code == 403) then 
            local token = api.findHeader(response,"x-csrf-token")
            if(token ~= nil) then 
                return token;
            end
        end

        logger:log(2,"Failed to get XCSRF token");
        return nil;
    end
end

function api.shortPoll(timeout,callback,arguments,callAnyway) --> needs rewrite later lmao
    local last;
    local invoked = false;

    coroutine.wrap(function()
        while(true) do 
            local s,e = pcall(function()
                local response,data = api.request(unpack(arguments));
                if(response.code == 200) then
                    if(data ~= last) then
                        if(invoked == false) then 
                            invoked = true;
                            if(callAnyway) then 
                                callback(data);
                            end
                        else
                            callback(data);
                        end
                    end
                    last = data;
                end
            end)
            timer.sleep(timeout or 10000);
        end
    end)();
end

return api;