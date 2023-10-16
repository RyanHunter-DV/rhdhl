local Pattern={};
local debug = require('common.debugMessagePrinter');debug.enable();
local blankRegexp = '[[:blank:]|\'\"\\.(),=;\\/\\?`\\*\\[\\]:]'

function Pattern:new(re,wholeWord)
	self = setmetatable(Pattern,{})
	--self.wholeWordOnly = wholeWord;
	self.pattern= re;
	if wholeWord then
		self.regexp = vim.regex(string.format("\\<%s\\>",re));
	else
		self.regexp = vim.regex(re);
	end
	return self;
end

-- private
function Pattern:offset(src)
	local s, e = self.regexp:match_str(src);
	if s then
		return s,e;
	else
		return nil,nil;
	end
end

-- public

-- check if the given string has a pattern in this object's field.
function Pattern:matched(s)
	local s, e = self:offset(s)
	if s then
		return true;
	else
		return false;
	end
end

-- give the matched position from the s.
-- if multiple time found, then start,end pairs
function Pattern:matchPosition(src)
	-- local s = src;
	local positions = {};local e=0;
	local len = string.len(src);
	-- local line= src;
	local filteredSrc = src;
	while e<len do
		local _s,_e = self:offset(filteredSrc);
		if not _s then
			break;
		end
		_s = e+_s;_e = e+_e;
		table.insert(positions,{s=_s,e=_e})
		filteredSrc=string.sub(src,_e+1,len);
		e=_e;
	end
	debug.d(string.format("getting matched position(%s) of line(%s)",vim.inspect(positions),line))
	return positions;
end


return Pattern;