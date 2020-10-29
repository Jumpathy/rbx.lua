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

function module.run(authentication,groupId,postId,callback)
    local endpoint = "https://groups.roblox.com/v1/groups/"..groupId.."/wall/posts/"..postId;
    local response,body = api.request("DELETE",endpoint,{},{},authentication,false,true);
    return response.code==200,response,json.decode(body)
end

return module;