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
        string.ulen(ustr)
            The UTF8 version of string.len.
        string.UTF8CharLen(unum)
            Return the number of bytes to encode a Unicode code in UTF8.
        string.uRealPos(ustr, pos)
            Return the real position(in UTF8) of a byte.
        string.MbtoUTF8table(mbstr)
            Return a table which contains the code of each UTF8 characters.
]]--

__ustring = {};
__ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};
--[[Magic Number, this is used to recongize each bytes.
   U+0000 ~ U+007F use Flag1
   U+0080 ~ U+07FF use Flag2
   U+0800 ~ U+FFFF use Flag3
]]--
__ustring.exception = {["invType"] = "ustring:invalid type", ["outRange"] = "ustirng:outside acceptable range", ["invPos"] = "ustirng:invalid character position"};--The exception list

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

function string.ulen(ustr)
    if(type(ustr) ~= "string") then
       return nil, __ustring.exception.invType;
    end

    local bytes, res, index = #ustr, 0, 1;
    local tmp_byte;

    while(index <= bytes) do
        tmp_byte = ustr:byte(index);
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

function string.UTF8CharLen(unum)
    if(type(unum) ~= "number") then
        return nil, __ustring.exception.invType;
    elseif(unum > 0xFFFF) then
        return nil, __ustring.exception.outRange;
    end

    if(unum >= 0x0800) then --U+0800 ~ U+FFFF uses 3 bytes
        return 3, nil;
    elseif(unum >= 0x0080) then --U+0080 ~ U+07FF uses 2 bytes
        return 2, nil;
    else                --U+0000 ~ U+007F uses 1 byte.
        return 1, nil;
    end
end

function string.uRealPos(ustr, pos)
    if(type(ustr) ~= "string") then
        return nil, __ustring.exception.invType;
    end

    if (math.ceil(pos)~= pos) then
            return nil, __ustring.exception.invPos;
    elseif(type(pos) ~= "number") then
            return nil, __ustring.exception.invType;
    end


    local len = #ustr;
    if((pos <-len) or (pos > len)) then
        return nil, __ustring.exception.outRange;
    elseif(pos == 0) then
        pos = 1;
    elseif(pos < 0) then        --From the back
        pos = len + pos + 1;
    end

    local byte = ustr:byte(pos);
    if(byte >= __ustring.MN.Flag1 and byte < __ustring.MN.Flag2) then --Adjust the pos to point at the first byte of the UTF8 character
        byte = ustr:byte(pos - 1);
        if(byte >= __ustring.MN.Flag2) then --this byte is the second byte of the UTF8 character
            pos = pos - 1;
        else
            pos = pos - 2;  --Otherwise it is the third byte of the UTF8 character.
        end
    end

    local res, index = 0, 1;

    while(index < pos) do
        byte = ustr:byte(index);
        if(byte < __ustring.MN.Flag1) then
            index = index + 1;
        else
            if(byte >= __ustring.MN.Flag3) then
                index = index + 3;
            else
                index = index + 2;
            end
        end
        res = res + 1;
    end

    return res + 1, nil;
end

function string.MbtoUTF8table(mbstr)
    if(type(mbstr) ~= "string") then
        return nil, __ustring.exception.invType;
    end
    local ubyte =
        function (a, b, c)
            local res = 0
            if(a < __ustring.MN.Flag1) then
                res = a;
            else
                if(a >= __ustring.MN.Flag3) then
                    res = (a - __ustring.MN.Flag3) * 4096 + (b - __ustring.MN.Flag1) * 64 + (c - __ustring.MN.Flag1);
                else
                    res = (a - __ustring.MN.Flag2) * 64 + (b - __ustring.MN.Flag1);
                end
            end
            return res;
        end

    local res = {};
    local index, bytes= 1, #mbstr;
    local tmp_byte;

    while(index <= bytes) do
        tmp_byte = mbstr:byte(index);
        if(tmp_byte < __ustring.MN.Flag1) then
            table.insert(res, tmp_byte);
            index = index + 1;
        else
            if(tmp_byte >= __ustring.MN.Flag3) then
                table.insert(res, ubyte(mbstr:byte(index, index + 2)));
                index = index + 3;
            else
                table.insert(res, ubyte(mbstr:byte(index, index + 1)));
                index = index + 2;
            end
        end
    end

    return res;
end

function string.UTF8tabletoMb(UTF8table)

end




