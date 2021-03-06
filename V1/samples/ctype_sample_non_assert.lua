--[[
    #FreInclude <ctype\ctype.lua>
]]--

--[[
    This is a sample which shows how to use ctype lib.
    In this sample, user only can input digits to display on the screen.
    P.S:You'd better use this with iLua.
]]--

charStack = {};
errString = "";

function on.charIn(char)
    local res, err = ctype.isdigit(char);
    if(err ~= nil) then
        if(err == ctype.exception.invChar)then
            errString ="Invalid character, please try again.";
        elseif(err == ctype.exception.invType) then
            errString ="Invalid type, please try again.";
        elseif(err == ctype.exception.longString) then
            errString = "Input is too long, please try again.";
        end
    elseif(res == true) then
        table.insert(charStack, char);
        errString = "";
    end
    platform.window:invalidate();
end

function on.backspaceKey()
    table.remove(charStack);
    platform.window:invalidate();
end


function on.paint(gc)
    gc:setColorRGB(0xffffff);
    gc:fillRect(0, 0, 320, 240);
    gc:setColorRGB(0x000000);

    gc:drawString("Input some character:", 0, 20);
    gc:drawString(table.concat(charStack), 0, 100);
    if(errString ~= "") then
        gc:drawString("error:" .. errString, 0, 150);
    end
end
