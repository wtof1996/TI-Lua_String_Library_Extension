--[[
    TI-Lua String Library Extension ---- ustring functions
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

   NOTE:This Lib is contains some basic functions to deal with UTF8 string in TI-Lua.
        If you want to use the Lua string-like class, please use the "ustring class".`
        Because of the limition of string.uchar, this Lib only support U+0000 ~ U+FFFF(0~65535).
        So the maximum of bytes in sequence is 3.
        For more detials of UTF8, please visit http://en.wikipedia.org/wiki/UTF-8


    Functions List:

    string.ubyte(uchar)
        The UTF8 version of string.byte.
    string.ulen(str)
        The UTF8 version of string.len.
]]--

__ustring = {};
__ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};--Magic Number
__ustring.exception = {["invType"] = "ustring:invalid type"};--The exception list

function string.ubyte(uchar)
    if(type(uchar) ~= "string") then
       return nil, __ustring.exception.invType;
    end
    local a, b, c, res = uchar:byte(1), uchar:byte(2), uchar:byte(3), 0;

    if(a < __ustring.MN.Flag1) then
        res = a;
    else
        if(a >= __ustring.MN.Flag3) then
            res = (a - __ustring.MN.Flag3) * 4096 + (b - __ustring.MN.Flag1) * 64 + (c - __ustring.MN.Flag1);
        else
            res = (a - __ustring.MN.Flag2) * 64 + (b - __ustring.MN.Flag1);
        end
    end

    return res, nil;
end

function string.ulen(str)
    if(type(str) ~= "string") then
       return nil, __ustring.exception.invType;
    end

    local bytes, res, index = #str, 0, 1;
    local tmp_byte;

    while(index <= bytes) do
        tmp_byte = str:byte(index);
        if(tmp_byte < __ustring.MN.Flag1) then
            index = index + 1;
        else
            if(tmp_byte >= __ustring.MN.Flag3) then
                index = index + 3;
            else
                index = index + 2;
            end
        end
        res = res + 1;
    end

    return res, nil;
end

function string.UTF8CharLen(num)

end

function string.uRealPos(str, pos)

end

function string.MbtoUTF8table(mbstring)

end

function string.UT8tabletoMb(UTF8table)

end




