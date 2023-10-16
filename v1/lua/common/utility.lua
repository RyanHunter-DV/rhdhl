-- the common lib processing with nvim apis.

local utility={};

utility.getCursorPosition = function()
	local vimpos = vim.api.nvim_win_get_cursor(0); -- (row,col)
	local pos = {row=vimpos[1],col=vimpos[2]};
	return pos;
end

utility.getCurrentLineInfo = function()
	local lineinfo = vim.api.nvim_get_current_line();
	return lineinfo;
end

utility.getAllLines = function(buf)
	return vim.api.nvim_buf_get_lines(buf,0,-1,1);
end


return utility;