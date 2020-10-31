local module = {
	authenticationRequired = true;
};

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

function module.run(authentication,transactionType)
	local run = function(userId)
		if(userId ~= nil) then
			local endpoint = "https://economy.roblox.com/v1/users/"..userId.."/transactions?transactionType="..transactionType.."&limit=100"
			local response,body = api.request("GET",endpoint,{},{},authentication,false,false);

			if(response.code == 200) then 
				local pageClass = function(body)
					local jsonData = json.decode(body);
					local current = jsonData["data"];
					local methods = {};
					local internal = {
						pages = {};
						pointers = {
							nextCursor = jsonData["nextPageCursor"];
							currentPage = 1;
						}
					};

					function methods.nextPage(callback)
						if(internal.pointers.nextCursor ~= nil) then 
							local response,body = api.request("GET",endpoint.."&cursor="..internal.pointers.nextCursor,{},{},authentication,false,false);
							if(response.code == 200) then 
								local jsonData = json.decode(body);
								internal.pointers.nextCursor = jsonData["nextPageCursor"];
								current = jsonData["data"];
								table.insert(internal.pages,jsonData["data"]);
								internal.pointers.currentPage = internal.pointers.currentPage + 1;
								return (jsonData["data"]);
							else
								logger:log(1,"Invalid cursor!");
							end
						else
							logger:log(1,"No next page!");
						end
					end 

					function methods.previousPage(callback)
						if(internal.pointers.currentPage >= 2) then 
							internal.pointers.currentPage = internal.pointers.currentPage - 1;
							current = internal.pages[internal.pointers.currentPage];
							return (internal.pages[internal.pointers.currentPage]);
						else 
							logger:log(1,"No previous page to go to!");
						end
					end

					function methods.getPage()
						return current,internal.pointers.currentPage;
					end

					function methods.getPages()
						return copyTable(internal.pages);
					end 

					return class.new("Page",methods);
				end

				return (pageClass(body));
			else 
				logger:log(1,"Invalid user!");
			end
		else
			logger:log(1,"Invalid int provided for `userId`")
		end
	end

	return run(client.userId);
end

return module;