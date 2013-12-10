--[[
    TI-Lua String Library Extension ---- ctype (assert support version)
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

    Notice: This Lib ONLY ACCEPT SINGLE ASCII CHAR!(either num or a string which contains one character is ok.)

    Each functions returns two value: res & err.
    For testing functions, res can be 1(true), 0(false) or nil.For converting functions, res can be result or nil(if input is invalid).
    P.S:I use the numeric instead of the Boolean was because wehn you return a value to assert , it would throw an error.
        If you still want to use Boolean, just use ctype["flase"] instead of false, ctype["true"] instead of true.Like this

        local res = assert(ctype.isalpha("a"));
        if(res == ctype["true"]) then
         ...
        end

    When res is nil,it means an error occured,the err will contain a short discription.Otherwise the err will be nil.
    Suggestion:If you have an error handler(by platform.registerErrorHandler), please use assert function like this:
        test_result = assert(isnumber("1"));
    If there's something wrong it will throw an error, then you can deal it in your handler.

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

    Public functions:

        Testing functions:
            ctype.isalnum(char)
            ctype.isalpha(char)
            ctype.isblank(char)
            ctype.iscntrl(char)
            ctype.isdigit(char)
            ctype.isgraph(char)
            ctype.islower(char)
            ctype.isprint(char)
            ctype.ispunct(char)
            ctype.isspace(char)
            ctype.isupper(char)
            ctype.isxdigit(char)

        Converting functions:
            ctype.tolower(char)
            ctype.toupper(char)


]]--

ctype = {};
--The exception  table
ctype.exception = {["invChar"] = "ctype:invalid character", ["invType"] = "ctype:invalid type", ["longString"] = "ctype:the string is too long"};

--The meaning result of testing functions
ctype["false"] = 0;ctype["true"] = 1;

--This private function is used to check input & convert all kinds of input into number.
function ctype.CheckInput(input)
    if(type(input) == "number") then
        if((input > 0x7F) or (input < 0) or (math.ceil(input)) ~= input)  then return nil, ctype.exception.invChar end;
        return input;
    elseif(type(input) == "string") then
        if(#input > 1) then return nil, ctype.exception.longString end;
        local res = input:byte();
        if((res > 0x7F) or (res < 0))  then return nil, ctype.exception.invChar end;
        return res;
    else
        return nil, ctype.exception.invType;
    end
end

--Public function
function ctype.isalnum(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39)) or
        ((res >= 0x41) and (res <= 0x5A))  or
        ((res >= 0x61) and (res <= 0x7A))
       ) then return 1, nil end;
    return 0, nil;
end

function ctype.isalpha(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x41) and (res <= 0x5A))  or
        ((res >= 0x61) and (res <= 0x7A))
       ) then return 1, nil end;
    return 0, nil;
end

function ctype.isblank(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( (res == 0x09) or (res == 0x2D) ) then return 1, nil end;
    return 0, nil;
end

function ctype.iscntrl(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res < 0x20) or (res == 0x7F))) then return 1, nil end;
    return 0, nil;
end

function ctype.isdigit(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39))) then return 1, nil end;
    return 0, nil;
end

function ctype.isgraph(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x21) and (res <= 0x7E))) then return 1, nil end;
    return 0, nil;
end

function ctype.islower(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x61) and (res <= 0x7A))) then return 1, nil end;
    return 0, nil;
end

function ctype.isprint(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x20) and (res <= 0x7E))) then return 1, nil end;
    return 0, nil;
end

function ctype.ispunct(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x21) and (res <= 0x2F))  or
        ((res >= 0x3A) and (res <= 0x40))  or
        ((res >= 0x5B) and (res <= 0x60))  or
        ((res >= 0x7B) and (res <= 0x7E))
       ) then return 1, nil end;
    return 0, nil;
end

function ctype.isspace(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x09) and (res <= 0x0D))  or
        (res == 0x20)
       ) then return 1, nil end;
    return 0, nil;
end

function ctype.isupper(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x41) and (res <= 0x5A))) then return 1, nil end;
    return 0, nil;
end

function ctype.isxdigit(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39))  or
        ((res >= 0x41) and (res <= 0x46))  or
        ((res >= 0x61) and (res <= 0x66))
       ) then return 1, nil end;
    return 0, nil;
end

function ctype.tolower(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if(ctype.isalpha(res)) then
        if(res < 0x61) then
            return res + 0x20;
        end
        return res;
    end
    return nil, ctype.exception.invChar;
end

function ctype.toupper(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if(ctype.isalpha(res)) then
        if(res > 0x5A) then
            return res - 0x20;
        end
        return res;
    end
    return nil, ctype.exception.invChar;
end
