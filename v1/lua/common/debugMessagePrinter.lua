local debugger={};
local isDebugMode=false;

debugger.enable = function()
	isDebugMode=true;
end

local __FILE__=function()
	local s=debug.getinfo(3,'S').source;
	return vim.loop.fs_realpath(string.sub(s,2,-1));
end
local __LINE__=function()
	return debug.getinfo(3,'l').currentline;
end

debugger.d = function(msg)
	local f=__FILE__();
	local l=__LINE__();
	if (isDebugMode) then
		print(string.format("%s,%d:[DEBUG] %s",f,l,msg));
	end
end


return debugger;
