local logger = require("./dependencies/logger");
local package = require("./package");
local coro = require("coro-http");

logger:log(3,"Rbx.lua v"..package["version"]);
coroutine.wrap(function() 
    local response,body = coro.request("GET","https://raw.githubusercontent.com/iiToxicity/rbx.lua/main/package.lua");
    if(response.code == 200) then
        local liveVersion = loadstring(body)()["version"];
        if(liveVersion ~= package["version"]) then 
            logger:log(2,string.format("Rbx.lua is outdated! Your version is %s and the live version is %s",package["version"],liveVersion));
        end
    end
end)();

return {
    client = require("./dependencies/client");
}