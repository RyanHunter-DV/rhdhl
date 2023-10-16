local debug=require('common.debugMessagePrinter'); debug.enable();
local Context={};
local ui=require('common.utility');
local Pattern=require('common.pattern');
local blankRegexp = '[[:blank:]|\'\"\\.(),=;\\/\\?`\\*\\[\\]:]'

-- local apis --
function Context:new()
	local self=setmetatable(Context,{})
	self.previousWord = '';
	return self;
end

function Context:isInBlankPosition(content,index)
	-- check if current index is in the content's blank space.
	if content=='' then
		return true;
	end
	local blankCharPattern=Pattern:new(blankRegexp,false);
	if blankCharPattern:matched(string.sub(content,index,index+1)) then
		return true;
	end
	return false;
end

-- input content must not be empty, and index of the content must not
-- a blank char.
function Context:extractWholeWord(content,index)
	local blankCharPattern=Pattern:new(blankRegexp,false);
	local s=index;local e=index;
	local len = string.len(content);
	while s >= 0 do
		if blankCharPattern:matched(string.sub(content,s,s+1)) then
			-- hello word, then s is 5, then the start position shall
			-- be 6
			s=s+1;
			break;
		end
		s= s - 1;
	end
	if s<0 then
		s=0;
	end
	while e < len do
		if blankCharPattern:matched(string.sub(content,e,e+1)) then
			e=e-1;
			break;
		end
		e = e+1;
	end
	debug.d(string.format("extract word(start:%d,end:%d) from(%s), cursor index is %d",s,e,content,index));
	-- string.sub uses the index as 1 based, not 0 based
	return string.sub(content,s+1,e+1);
end

-- public apis --
function Context:filterCurrentPatternWord()
	-- function to filter out word that current cursor located.
	local lineinfo = ui.getCurrentLineInfo();
	local pos = ui.getCursorPosition();

	if self:isInBlankPosition(lineinfo,pos.col) then
		return nil;
	end
	local word = self:extractWholeWord(lineinfo,pos.col);
	return word;
end

-- check if the given current word is different then self.previousWord, if is
-- then return true and refresh the self.previousWord.
function Context:wordChanged(current)
	if self.previousWord == current then
		return false;
	end
	self.previousWord = current;
	return true;
end

-- search the whole file, marks all positions of the word that equals the given word.
function Context:searchAllMatchedPositions(word)
	local ptrn = Pattern:new(word,true);
	local lines= ui.getAllLines(0);
	local positions={};
	for _,line in ipairs(lines) do
		local linepos = ptrn:matchPosition(line);
		table.insert(positions,linepos);
	end
	return positions;
end


return Context;