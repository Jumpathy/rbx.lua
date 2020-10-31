--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Author: Toxic#2799
Usage: API-based web functionality, such as XCRSF, cookie logins, and more. This is used in every web-based function.
]]

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

return api;