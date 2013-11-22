--[[
    TI-Lua String Library Extension ---- ctype
    Copyright 2013 wtof1996

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]--


--[[
    Notice: This Lib ONLY ACCEPT SINGLE ASCII CHAR!(either num or a string which contains one character is ok.)

    Each functions returns two value: res & err.
    For testing functions, res can be true, false or nil.For converting functions, res can be result or nil.
    When res is nil,it means an error occured,the err will contain a short discription.Otherwise the err will be nil.
    Suggestion:If you have an error handler(by platform.registerErrorHandler), please use assert function like this:
        test_result = assert(isnumber("1"));
    If there's something wrong it will throw an error, then you can deal it in your handler.

]]--

--[[
    ASCII Table:

    HEX         characters
    0x00-0x08   control codes(NUL, etc.)
    0x09        tab(\t)
    0x0A-0x0D   whitspaces(\n,\v,\f,\r)
    0x0E-0x1F   control codes
    0x20        space
    0x21-0x2F   !"#$%'()*+,-./
    0x30-0x39   0123456789
    0x3A-0x40   :'<=>?@
    0x41-0x46   ABCDEF
    0x47-0x5A   GHIJKLMNOPQRSTUVWXYZ
    0x5B-0X60   [\]^_`
    0x61-0x66   abcdef
    0x67-0x7A   ghijkllmnopqrstuvwxyz
    0x7B-0x7E   {|}~
    0x7F        backspace character(DEL)
]]--

ctype = {};
--The exception  table
ctype.exception = {["invChar"] = "ctype:invalid character", ["invType"] = "ctype:invalid type", ["longString"] = "ctype:the string is too long"};

--This private function is used to check input & convert all kinds of input into number.
function ctype.CheckInput(input)
    if(type(input) == "number") then
        if((input > 0x7F) or (input < 0) or (math.ceil(input)) ~= input)  then return nil, "ctype:invalid character" end;
        return input;
    elseif(type(input) == "string") then
        if(#input > 1) then return nil, "ctype:the string is too long" end;
        local res = input:byte();
        if((res > 0x7F) or (res < 0))  then return nil, "ctype:invalid character" end;
        return res;
    else
        return nil, "ctype:invalid type";
    end
end

--Public function
function ctype.isalnum(char)
    local res, err = ___ctypeCheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39)) or
        ((res >= 0x41) and (res <= 0x5A))  or
        ((res >= 0x61) and (res <= 0x7A))
       ) then return true, nil end;
    return false, nil;
end

function ctype.isalpha(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x41) and (res <= 0x5A))  or
        ((res >= 0x61) and (res <= 0x7A))
       ) then return true, nil end;
    return false, nil;
end

function ctype.isblank(char)

end

function ctype.iscntrl(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res < 0x20) or (res == 0x7F))) then return true, nil end;
    return false, nil;
end

function ctype.isdigit(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39))) then return true, nil end;
    return false, nil;
end

function ctype.isgraph(char)

end

function ctype.islower(char)

end

function ctype.isprint(char)

end

function ctype.ispunct(char)

end

function ctype.isspace(char)

end

function ctype.isupper(char)

end

function ctype.isxdigit(char)

end

function ctype.tolower(char)

end

function ctype.toupper(char)

end
