-- Base code provided by: https://github.com/SinisterRectus/Discordia/blob/master/libs/utils/Logger.lua (I optimized it to my needs.)

local logger = {};

function logger:log(level, msg, placeholder)
	local tags = {
		{'ERROR', 31},
		{'WARNING', 33},
		{'INFO', 32},
		{'DEBUG', 36},
	}

	local tag = tags[level];
	local time = os.date("%Y-%m-%d %H:%M:%S",os.time());
	if not tag then return end;

	placeholder = placeholder or tag[1];
	local tag = string.format('\27[%i;%im%s\27[0m', bold or 1, tag[2], string.format("[%s]",placeholder));
	msg = string.format(msg);
	
	_G.process.stdout.handle:write(string.format('%s | %s | %s\n',time, tag, msg));
	return msg;
end

return logger;