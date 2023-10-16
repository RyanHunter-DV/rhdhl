-- This is the initial file that will be required directly by user like:
-- require('rhdhl')


local debug = require('common.debugMessagePrinter');debug.enable();
local Highlight = require('rhdhl.highlight');
local Context   = require('rhdhl.context');
local Autocmd   = require('common.autocmd');

local rhdhl = {};
local hl = Highlight:new();
local ctx= Context:new();
local au = Autocmd:new('__RHDHL_AUG__');

local actionsWhenCursorMoved = function()
	local word = ctx:filterCurrentPatternWord();
	if word ==nil then
		-- if locates in invalid position, then to clear
		-- last marks if has and return immediately.
		hl:clearMarks();
		return;
	end
	debug.d(string.format("getting current cursor pattern(%s)",word));
	-- if the word in new position is same as before,
	-- then it will do nothing.
	-- if (ctx.wordChanged(word)) then
	hl:clearMarks();
	local positions = ctx:searchAllMatchedPositions(word);
	hl:setMarks(word,positions);
	-- end
end

-- no user configs in this version
rhdhl.setup = function()
	hl:createNamespaceAndHighlightGroup();
	au:subscribe({'CursorMoved'},actionsWhenCursorMoved);
end



return rhdhl;