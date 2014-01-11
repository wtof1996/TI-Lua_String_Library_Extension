--[[
    #FreInclude <ustring\functions\ustring.lua>
]]--

--[[
    This is a simple sample which shows how to use ustring functions lib.
    You'd better use this with iLua.
]]--

toolpalette.enablePaste(true);

orgiString = "";
displayBuff = {};

function on.paint(gc)
    if(orgiStrong == "") then
        gc:drawString("Paste a string here", 120, 120);
        return;
    end
    
    gc:drawString(orgiString, 0, 20); --Orginal String
    local Height = 40;
    for i, v in pairs(displayBuff) do
        gc:drawString(v, 0, Height);
        Height = Height + 20;
    end
end

function on.paste()
    orgiString = clipboard.getText();
    displayBuff = {};
    
    table.insert(displayBuff, "len:" .. string.ulen(orgiString));
    table.insert(displayBuff, "bytes:" .. string.len(orgiString));
    
    local t = string.MbtoUTF8table(orgiString);
    table.sort(t);
    table.insert(displayBuff, "sorted str:" .. string.UTF8tabletoMb(t));
    
    platform.window:invalidate();
end