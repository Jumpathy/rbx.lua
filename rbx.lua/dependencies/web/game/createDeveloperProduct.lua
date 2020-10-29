

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

function module.run(authentication,placeId,details,callback)
	local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
	local querystring = require("querystring");

	local response,body = api.request("GET",endpoint,{},{},authentication,false,false);
	if(response.code == 200) then 
		local id = json.decode(body)["UniverseId"];
		local endpoint = "https://develop.roblox.com/v1/universes/"..id.."/developerproducts";
		local price = details.price or 1;
		local description = details.description or "N/A";
		local name = details.name or "N/A";
		local endpoint = endpoint.."?"..querystring.stringify({
			name = name;
			description = description;
			priceInRobux = price;
		},nil,nil,{
			encodeURIComponent = "gbkEncodeURIComponent"
		})

		local response,body = api.request("POST",endpoint,{
            {"Content-Length",0}
        },{},authentication,true,true);
		if(response.code == 200) then 
			return true,json.decode(body)["shopId"];
		else 
			logger:log(1,"Something went wrong.");
			return false,response
		end
	else
		logger:log(1,"Invalid placeId!");
	end
end

return module;