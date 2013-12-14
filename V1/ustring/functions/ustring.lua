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
]]--

__ustring = {};
__ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};
--Magic Number
__ustring.exception = {["invType"] = "ustring:invalid type"};

function string.ubyte(str)
    if(type(str) ~= "string") then
        error(ustring.exception.invType);
    end
    local a, b, c, res = str:byte(1), str:byte(2), str:byte(3), 0;

    if(a < __ustring.MN.Flag1) then
        res = a;
    else
        if(a > __ustring.MN.Flag3) then
            res = (a - __ustring.MN.Flag3) * 4096 + (b - __ustring.MN.Flag1) * 64 + (c - __ustring.MN.Flag1);
        else
            res = (a - __ustring.MN.Flag2) * 64 + (b - __ustring.MN.Flag1);
        end
    end


    return res;
end

function string.ulen(str)

end

function string.UTF8CharLen(num)

end

function string.uRealPos(str, pos)

end

function string.MbtoUTF8table(mbstring)

end

function string.UT8tabletoMb(UTF8table)

end




