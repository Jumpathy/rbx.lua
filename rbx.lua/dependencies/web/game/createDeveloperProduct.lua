local module = {
	authenticationRequired = true;
};

function module.run(authentication,placeId,details)
	local querystring = require("querystring");
	local endpoint = "https://www.roblox.com/places/api-get-details?assetId="..placeId;
	local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

	if(response.code == 200) then 
		local id = json.decode(body)["UniverseId"];
		local endpoint = "https://develop.roblox.com/v1/universes/"..id.."/developerproducts";
		local price = details.price or 1;
		local description = details.description or "N/A";
		local name = details.name or "N/A";
		local endpoint = endpoint.."?"..querystring.stringify({name = name;description = description;priceInRobux = price},nil,nil,{encodeURIComponent = "gbkEncodeURIComponent"})

		local response,body = api.request("POST",endpoint,{{"Content-Length",0}},{},authentication,true,true);
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