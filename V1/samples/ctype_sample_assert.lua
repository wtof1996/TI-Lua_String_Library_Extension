--[[
    #FreInclude <ctype\ctype_assert.lua>
]]--

--[[
    This is a sample which shows how to use ctype_assert lib.
    In this sample, user only can input digits to display on the screen.
    P.S:This sample only can run under API2.0 or higher.
	You'd better use this with iLua.
]]

platform.apiLevel = '2.0'

charStack = {};
errString = "";


errorHandler = {};
function errHandler(lineNumber, errMsg, stack, locals)
    errMsg = errMsg:sub(#tostring(lineNumber) + 3, -1);--Split the line number & error message

    if(errMsg == ctype.exception.invChar)then
        errString ="Invalid character, please try again.";
    elseif(errMsg == ctype.exception.invType) then
        errString ="Invalid type, please try again.";
    elseif(errMsg == ctype.exception.longString) then
        errString = "Input is too long, please try again.";
    else
        return false;
    end

    platform.window:invalidate();
    return true;
end
platform.registerErrorHandler(errHandler);

function on.charIn(char)
    local res = assert(ctype.isdigit(char));

    if(res == ctype["true"]) then
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
