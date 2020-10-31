--[[
       _               _             
      | |             | |            
  _ __| |____  __     | |_   _  __ _ 
 | '__| '_ \ \/ /     | | | | |/ _` |
 | |  | |_) >  <   _  | | |_| | (_| |
 |_|  |_.__/_/\_\ (_) |_|\__,_|\__,_|

Author: Toxic#2799
Usage: Creating the client object which initializes your base. This contains authorization, configuration, and some events.
]]

return function(configuration)
	local utility = require("./utility");
	local class = require("./class");
	local events = require("./events");
	local api = require("./api");
	local logger = require("./logger");
	local json = require("json");
	local configuration = utility.resolveConfiguration(configuration);
	local modules = {};
	local nonauthenticated = {};
	local setEnv = {};
	local internal = {};
	local client = {};
	local isReady = false;

	local search = {
		user = {"getTransactionHistory","acceptFriendRequest","getRobuxAmount","blockUser","currentAuthenticated","declineAllFriendRequests","declineFriendRequest","followUser","getDescription","getFollowerCount","getFollowersList","getFollowingCount","getFollowingList","getFriendRequestAmount","getFriendRequestList","getFriendsCount","getFriendsList","getGroups","getOnlineFriends","getPastNames","getStatus","getUser","searchUsernames","sendFriendRequest","setStatus","unfollowUser"},
		group = {"getRevenue","getSales","getRobuxAmount","payout","acceptJoinRequest","declineJoinRequest","deleteWallPost","deleteWallPostsByUser","exileUser","getAuditLogs","getJoinRequests","getRoleId","getRoles","getUsers","getWall","rankUser","shout","updateDescription"},
		game = {"createDeveloperProduct","dislike","favorite","getDetails","getPrice","getServers","getUniverseId","getVotes","like","modifyDeveloperProduct","unfavorite"},
	}

	local env = {
		test = true,
		client = client, 
		api = api, 
		logger = logger,
		events = events, 
		class = class, 
		http = require("coro-http"), 
		json = json,
		utility = utility
	};

	local eventList = {
		ready = utility.unique("ready");
	}

	client.functions = {
		resolveToUsername = utility.resolveToUsername,
		resolveToUserId = utility.resolveToUserId
	};

	for folder,moduleHolder in pairs(search) do 
		for key,module in pairs(moduleHolder) do 
			if(type(module) == "string") then
				local real = require("./web/"..folder.."/"..module);
				if(modules[folder] == nil) then 
					modules[folder] = {};
				end 

				real.name = module;
				real.env = env;
				modules[folder][module] = real;
				modules[folder][key] = nil;
				
				for k,v in pairs(env) do
					getfenv(real.run)[k] = v;
				end

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

	events.new(eventList.ready,function(...)end)
	return utility.readOnly(client,"client");
end