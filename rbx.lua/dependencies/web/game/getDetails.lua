
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
		local id = json.decode(body)["UniverseId"];
		local details = "https://games.roblox.com/v1/games?universeIds="..id;
		local response,body = api.request("GET",details,{},{},authentication,false,false)
		if(response.code == 200) then 
			body = json.decode(body)["data"][1];
			if(body.creator.type == "Group") then 
				local response,secondaryBody = api.request("GET","https://groups.roblox.com/v1/groups/"..body.creator.id,{},{},authentication,false,false)
				if(response.code == 200) then 
					body.creator.real = json.decode(secondaryBody)["owner"]["userId"];
					return body;
				end
			else 
				body.creator.real = body.creator.id;
				return body;
			end
		else 
			logger:log(1,"Something went wrong.");
		end
	else
		logger:log(1,"Invalid placeId!");
	end
end

return module;