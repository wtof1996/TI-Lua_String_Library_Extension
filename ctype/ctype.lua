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
    Suggestion:Use assert function to deal with error massage like this:
        test_result = assert(isnumber("122"));

    _ctypeInput is a private function, which used to check your input and do some convert.
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

--This private function is used to check input & convert all kinds of input into number.
function ___ctypeCheckInput(input)
    if(type(input) == "number") then
        if((input > 0x7F) or (input < 0) or (math.ceil(input)) ~= input)  then return nil, "ctype:invalid character" end;
        return input;
    elseif(type(input) == "string") then
        if(#input > 1) then return nil, "ctype:the string is too long" end;
        local res = input:byte();
        if((res > 0x7F) or (res < 0) or (math.ceil(res)) ~= res)  then return nil, "ctype:invalid character" end;
        return res;
    else
        return nil, "ctype:invalid type";
    end
end

--Public function
function isalnum(char)

end

function isalpha(char)

end

function isblank(char)

end

function iscntrl(char)

end

function isdigit(char)

end

function isgraph(char)

end

function islower(char)

end

function isprint(char)

end

function ispunct(char)

end

function isspace(char)

end

function isupper(char)

end

function isxdigit(char)

end

function tolower(char)

end

function toupper(char)

end
