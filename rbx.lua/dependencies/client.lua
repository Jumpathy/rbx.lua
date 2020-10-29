--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Contact: Toxic#2799

Note: This code is most-likely very inefficient as of it's release. If this project fails, it wasn't worth writing all this great code for < 10 people to actually end up using it.
If it receives some form of community, I'm 100% going to be doing massive updates to add new functions and rewrite parts of the code.
- Toxic
]]

return function()
	local configuration = require("./../configuration");
	local class = require("./class");
	local events = require("./events");
	local logger = require("./logger");
	local api = require("./api");
	local utility = require("./utility");
	local json = require("json");
	local modules = {};
	local nonauthenticated = {};
	local setEnv = {};
	local internal = {};
	local client = {};
	local isReady = false;

	local search = {
		user = {"acceptFriendRequest","blockUser","currentAuthenticated","declineAllFriendRequests","declineFriendRequest","followUser","getDescription","getFollowerCount","getFollowersList","getFollowingCount","getFollowingList","getFriendRequestAmount","getFriendRequestList","getFriendsCount","getFriendsList","getGroups","getOnlineFriends","getPastNames","getStatus","getUser","searchUsernames","sendFriendRequest","setStatus","unfollowUser"},
		group = {"acceptJoinRequest","declineJoinRequest","deleteWallPost","deleteWallPostsByUser","exileUser","getAuditLogs","getJoinRequests","getRoleId","getRoles","getUsers","getWall","rankUser","shout","updateDescription"},
		game = {"createDeveloperProduct","dislike","favorite","getDetails","getPrice","getServers","getUniverseId","getVotes","like","modifyDeveloperProduct","unfavorite"},
		functions = {"resolveToUserId", "resolveToUsername"}
	}

	local eventList = {
		shout = "shout";
		wallPost = "wallPost";
		ready = utility.unique("ready");
	}

	for folder,moduleHolder in pairs(search) do 
		for key,module in pairs(moduleHolder) do 
			if(type(module) == "string") then
				local real = require("./web/"..folder.."/"..module);
				if(modules[folder] == nil) then 
					modules[folder] = {};
				end 
				modules[folder][module] = real;
				modules[folder][key] = nil;
				setEnv[module] = real;

				if(real.authenticationRequired == false) then 
					if(nonauthenticated[folder] == nil) then 
						nonauthenticated[folder] = {};
					end
					nonauthenticated[folder][module] = real;
				end
			end
		end
	end
	
	local ready = function()
		isReady = true;
		events.invoke(eventList.ready);
	end

	local run = function(self,...)
		local arguments = {...};
		local security = arguments[1] or nil;
		local env = {client = client, api = api, logger = logger, events = events, class = class, http = require("coro-http"), json = json};

		for _,module in pairs(setEnv) do
			for k,v in pairs(env) do 
				getfenv(module.run)[k] = v;
			end
		end

		if(security ~= nil) then 
			logger:log(3,"Connecting to Roblox...");
			local response,body = api.request("GET","https://users.roblox.com/v1/users/authenticated",{},nil,security,false,true);
		
			if(response.code == 200) then 
				body = json.decode(body);
				logger:log(3,string.format("Authenticated as %s",body.name));
				client.userId = body.id;
				
				for k,v in pairs(modules) do 
					client[k] = {};
					for i,v in pairs(v) do 
						client[k][i] = function(...)
							return v.run(security,...);
						end
					end
				end
				
				ready();
			else 
				logger:log(1,"Invalid Roblox response, invalid cookie?");
			end
		else
			for k,v in pairs(nonauthenticated) do 
				client[k] = {};
				for i,v in pairs(v) do 
					client[k][i] = function(...) 
						return v.run(security,...);
					end
				end
			end
				
			ready();
		end
	end

	function client:on(event,...)
		local arguments = {...};
		local between = {};
		local callback = arguments[#arguments];
		if(#arguments >= 3) then
			table.insert(between,arguments[2]); 
		end

		callback = callback or function() end;
		if(type(callback) == "function") then 
			if(eventList[event] ~= nil) then 
				event = eventList[event];
				events.onEmitted(event,callback,between);
			else 
				logger:log(string.format("Event %q does not exist!",event));
			end
		end
	end

	function client:run(...)
		return coroutine.wrap(run)(self,...);
	end

	function client.isReady()
		return isReady;
	end
	
	if(_G["event_shout"] == nil) then
		events.new(eventList.ready,function(...)end)
		events.new(eventList.shout,function(...)end)
		events.new(eventList.wallPost,function(...)end)

		_G["event_shout"] = function(arguments)
			local groupId = tostring(arguments[1]);
			if(groupId ~= nil) then 
				if(internal[groupId.."-shout"] == nil) then 
					internal[groupId.."-shout"] = true;
					local last = "";
					local lastId = "";
					local count = 0;

					api.shortPoll(configuration.shortPollDelay,function(data)
						local data = json.decode(data);
						if(data["shout"] ~= nil) then 
							if(json.encode(data["shout"]) ~= last) then
								if(data["shout"]["body"] ~= lastId) then
									last = json.encode(data["shout"]);
									lastId = data["shout"]["body"];
									if(count >= 1) then
										events.invoke("shout",data["shout"],arguments[1]);
									else 
										count = count + 1;
									end
								end
							end
						end
					end,{"GET","https://groups.roblox.com/v1/groups/"..groupId},true);
				end
			end
		end

		_G["event_wallPost"] = function(arguments)
			local groupId = tostring(arguments[1]);
			if(groupId ~= nil) then 
				if(internal[groupId.."-wallPost"] == nil) then 
					internal[groupId.."-wallPost"] = true;
					local invoked = false;
					local cache = {};
					local highest = 0;

					api.shortPoll(configuration.shortPollDelay,function(data)
						local post = json.decode(data)["data"][1];
						local last = "";
						if(post ~= nil) then
							if(post.id ~= last) then
								if(invoked == true) then
									if(cache[post.id] == nil) then 
										if(post.id > highest) then 
											highest = post.id;
											cache[post.id] = true;
											events.invoke("wallPost",post,arguments[1]);
											last = post.id;
										end
									end
								else 
									invoked = true;
								end
							end
						end
					end,{"GET","https://groups.roblox.com/v1/groups/"..groupId.."/wall/posts?sortOrder=Desc"});
				end
			end
		end
	end

	return utility.readOnly(client,"client");
end