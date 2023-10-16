local s=debug.getinfo(3,'S').source;
local pathinfo = io.pathinfo(vim.loop.fs_realpath(string.sub(s,2,-1)));
print(string.format("main, loading lib path: (%s)",pathinfo.dirname));
package.path = pathinfo.dirname..package.path;

local debug = require('common.debugMessagePrinter');debug.enable();
local Highlight = require('rhdhl.highlight');

local hl = Highlight:new();

debug.d("test creating namespace and highlight group");
hl.createNamespaceAndHighlightGroup();
debug.d("namespace:",vim.inspect(hl.ns));
debug.d(string.format("test highlight by cmd: highlight %s",hl.hlGroupName));

local word='testword'
debug.d("testing setmarks");
hl.setMarks(word);


local positions;