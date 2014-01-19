--[[
    TI-Lua String Library Extension ---- ustring class
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

ustring = class();

--public member

--the constructer
function ustring:init(init_data)
    
    --metatable
    local t = {};
    t.__concat = self.concat;
    t.__len = self.len;
    t.__eq = self.equal;
    t.__index = self.get;
    t.__newindex = self.set;
    t.__tostring = self.get_str;
    
    --data initialization
    self.data = {};
    self.isempty = false;
    
    if(type(init_data) == "string") then
        self.data = ___ustring.Mb2UTF8t(init_data);
    elseif(type(init_data) == "table") then
        self.data = init_data;
    else
        self.isempty = true;
    end
    
    self.length = #self.data;
    
    setmetatable(self, t);
end

function ustring:push_back(unum)

end

function ustring:clear()
  
end

function ustring:append(b)

end

function ustring:erase(a, b)

end

function ustring:insert(str, index)
  
end

function ustring:resize(size)

end

function ustring:find(str, a, b)

end

function ustring:sub(a, b)
  
end

function ustring:get(index)
  
end

function ustring:set(index, d)
  
end

function ustring:get_str()
  
end

function ustring:len()

end

function ustring:concat(b)

end

function ustring:equal(b)
  
end

--private member, which begin with 3 underscores
___ustring = {};
___ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};
--[[Magic Number, this is used to recongize each bytes.
   U+0000 ~ U+007F use Flag1
   U+0080 ~ U+07FF use Flag2
   U+0800 ~ U+FFFF use Flag3
]]--
function ___ustring.Mb2UTF8t(mbstr)
    local ubyte =
        function (a, b, c)
            local res = 0
            if(a < ___ustring.MN.Flag1) then
                res = a;
            else
                if(a >= ___ustring.MN.Flag3) then
                    res = (a - ___ustring.MN.Flag3) * 4096 + (b - ___ustring.MN.Flag1) * 64 + (c - ___ustring.MN.Flag1);
                else
                    res = (a - ___ustring.MN.Flag2) * 64 + (b - ___ustring.MN.Flag1);
                end
            end
            return res;
        end

    local res = {};
    local index, bytes= 1, #mbstr;
    local tmp_byte;

    while(index <= bytes) do
        tmp_byte = mbstr:byte(index);
        if(tmp_byte < ___ustring.MN.Flag1) then
            table.insert(res, tmp_byte);
            index = index + 1;
        else
            if(tmp_byte >= ___ustring.MN.Flag3) then
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