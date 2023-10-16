local debug = require('common.debugMessagePrinter');debug.enable();
local Highlight={};

local RHDHL = '__RHDHL_NS__';

-- local apis --
function Highlight:new()
	local self=setmetatable({},{__index=Highlight})
	self.ns = nil;
	self.hlGroupName = 'RhDhlHighlightGroup';
	self.fg = nil;
	self.bg = '414858';
	self.hasMarks = false;
	self.marks = {}; -- [index] = id
	return self;
end

function Highlight:createHighlightGroup()
	local hlcmd = 'highlight '..self.hlGroupName;
	if self.fg then
		hlcmd = hlcmd..string.format(" guifg=#%s",self.fg);
	end
	if self.bg then
		hlcmd = hlcmd..string.format(" guibg=#%s",self.bg);
	end
	debug.d(string.format("hlcmd: %s",hlcmd));
	vim.cmd(hlcmd);
end



-- external apis --
function Highlight:createNamespaceAndHighlightGroup()
	self.ns = vim.api.nvim_create_namespace(RHDHL);
	self:createHighlightGroup();
end

function Highlight:clearMarks()
	if self.hasMarks then
		for _,id in ipairs(self.marks) do
			vim.api.nvim_buf_del_extmark(0,self.ns,id);
		end
		self.marks = {}; -- clear marks
		self.hasMarks=false;
	end
	return;
end

-- positions[index] -> [row,col]
function Highlight:setMarks(pattern,positions)
	if self.hasMarks then
		debug.d("set new marks without clear it!");
		return;
	end
	self.hasMarks=true;
	-- local markid = 0;
	local patternLen = string.len(pattern);
	local _id=1;
	for lineIndex,pos in ipairs(positions) do
		lineIndex=lineIndex-1;
		if not vim.tbl_isempty(pos) then 
			for _,wordPos in ipairs(pos) do
				local opts={
					id = _id,
					end_col=wordPos.e,
					hl_group = self.hlGroupName,
					end_row=lineIndex
				}
				vim.api.nvim_buf_set_extmark(0,self.ns,lineIndex,wordPos.s,opts);
				table.insert(self.marks,_id);
				_id=_id+1;
			end
		end
	end
	return;
end


return Highlight;