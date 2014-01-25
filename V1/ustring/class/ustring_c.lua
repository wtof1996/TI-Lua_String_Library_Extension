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
fustring = {}; --The ustring's member function
--public member

--the constructer
function ustring:init(init_data)
    
    --metatable
    local t = {}, m;
    t.__concat = fustring.concat;
    t.__eq = fustring.equal;
    t.__index = fustring.get;
    t.__newindex = fustring.set;
    t.__tostring = fustring.get_str;
    
    
    --copy the function member from fustring
    for k, v in pairs(fustring) do
        self[k] = v;
    end
    
    --data initialization
    self.data = {};
    self.isempty = false;
    self.getchar = false;
    
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

function fustring:change_data(d)
  
end

function fustring:push_back(value)

    if(___ustring.checkUnicode == false) then return nil; end
    self.length = self.length + 1;
    table.insert(self.data, value);
    
end

function fustring:clear()
    self.data = {};
    self.length = 0;
    self.isempty = true;
    collectgarbage();
end


function fustring:erase(a, b)
    if(self.data[a] == nil) then return nil; end
    
    if(b ~= nil) then
        if(self.data[b] == nil or a > b) then return nil; end
        
        for i = a, b do
            table.remove(self.data, i);
        end
        self.length = self.length - (b - a + 1);
        
    end
end

function fustring:insert(str, index)
  
end

function fustring:resize(size)
    if( (type(size) ~= "number") or ((math.ceil(size)) ~= size) or size < 0) then
        return nil;
    end
    
    if(size == 0) then self:clear();return true; end
    
    
    
    if(size < self.length) then 
        for i = self.length, size + 1, -1 do
            table.remove(self.data);
        end
        self.length = size;
        collectgarbage();
        return true;
    end
   
    for i = self.length + 1, size do
        table.insert(self.data, 0);
    end
    
    self.length = size;
    
    return true;
    
end

function fustring:find(str, a, b)

end

function fustring:sub(a, b)
  
end

function fustring:get(index)
    if(self.data[index] == nil) then return nil; end
    if(self.getchar) then
        return string.uchar(self.data[index]);
    end
    
    return self.data[index];
end

function fustring:set(index, value)
    if((self.data[index] == nil) or
        (type(value) ~= "number") or
        (value < 0) or
        (value > 65535) or
        ((math.ceil(value)) ~= value)
      ) 
    then 
        return nil; 
    end
    self.data[index] = value;
end

function fustring:get_str()
    if(self.isempty) then return "" end;
    local res = {};
    for k, v in pairs(self.data) do
        res[k] = string.uchar(v);
    end

    return table.concat(res);
end

function fustring:concat(b)
    if(type(self) == "number") then 
          self = tostring(self);
    elseif(type(b) == "number") then 
          b = tostring(b); 
    end
    
    if(type(self) == "string") then 
          self = ustring(self);
    elseif(type(b) == "string") then 
          b = ustring(b); 
    end
    --In fact the concat accept two parameters, maybe self is a normal string and the b is a ustring, or self
    --is a ustring and b is a ustring.We need the convert in these cases.
    
    local res = self:copy();
    res.length = res.length + b.length;
    for k, v in pairs(b.data) do
        table.insert(res.data, v)
    end
    if(res.length ~= 0) then res.isempty = false; end;
    return res;
end

function fustring:equal(b)
    if(self.length ~= b.length) then return false; end
    
    local i = 1;
    while(
          (i <= self.length) and 
          (self.data[i] == b.data[i])) do 
        i = i + 1; 
    end
    if(i > self.length) then return true; end
    return false;
  
end


function fustring:copy() -- copy constructor
    local res = ustring();
    for k, v in pairs(self.data) do
        table.insert(res.data, v);
    end
    res.isempty = self.isempty;
    res.getchar = self.getchar;
    res.length = self.length;
    
    return res;
end
--private member, which begin with 3 underscores
___ustring = {};
___ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};
--[[Magic Number, this is used to recongize each bytes.
   U+0000 ~ U+007F use Flag1
   U+0080 ~ U+07FF use Flag2
   U+0800 ~ U+FFFF use Flag3
]]--

function ___ustring.checkUnicode(u)
    if((type(u) ~= "number") or
        (u < 0) or
        (u > 65535) or
        ((math.ceil(u)) ~= u)
      ) 
    then 
        return false; 
    end
    
    return true;
end

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
