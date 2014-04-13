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
   
   This lib provides a UTF8-supported string class for dealing with UTF8 string.
   You can just use this class like the original Lua string. And this class supports
   random access.
   The index is numbered from 1.
   
   operator:
        [] access/assign a index
        .. concat
        == equal
        tostring
        
   public member:
      
      member variables:
          N.B: It's hard to implement the read-only member, so BE CAREFUL when you use the "data" and "length" member.
               In fact many operations could be done by member function, so these members shouldn't be used directly.
               
          ustring.data
              An array that contains the sequence of characters that make up the value of the ustring object.
              Please DO NOT modify or overwrite this member! You should use the member functions to do the work.
          
          ustring.length
              The length of the string (i.e. the number of characters).
              If you want to read this member, use ustring:size() instead.
              Please DO NOT modify or overwrite this member! You should use the member functions to do the work.
          
          ustring.getchar
              A boolean value indicates the return value type of ustring.get and the "[]" operator
             (only for the indexing access). If it is true, it will return a character, or it will return a Unicode code.
             The default value is false.
      
      member functions:
          
          ustring(), ustring(<string>), ustring(<unicode table>)
            The construct function.
 
          ustring:assign(<string>), ustring:assign(<unicode table>)
            Assign content to the ustring object.
          
          ustring:clear()
            Clear the content of the ustring object.
          
          ustring:concat(<ustring>), ustring:concat(<string>), ustring:concat(<number>)
            Concat two ustring object or string.If input is a number, the number will be convert into a ustring object.
            The operator ".." is overloaded from this function.
          
          ustring:copy()
            The copy constructor, return a copy form the ustring object.
          
          ustring:erase(a, [b])
            Erases part of the ustring object, reducing its length.
            If b is not specificed, the character at position a will be erased; Otherwise this erases the sequence 
            of characters in the range [a, b].
            
          ustring:equal(b)
            Test if the ustring object is equal to ustring object b.
            The operator "==" is overloaded from this function.
            
          ustring:find(str)
            Find content str in the ustring object. If it finds a match, the function returns the first index of str where this occurrence 
            starts and ends; otherwise, it returns nil. This uses "Naive string search algorithm", so the asymptotic time complexity is O(mn).
          
          ustring:get(index)
            Get a character form the ustring object. The return value depends on ustring.getchar.
            The indexing access operator "[]" overloaded from this function.
        
          ustring:get_str()
            Returns a Lua orginal string in UTF8 encode which contains a sequence of characters 
            that make up the value of the ustring object.
        
          ustring:insert(str, index)
            Inserts additional characters into the ustring object before the character indicated by index.
        
          ustring:isempty()
            Returns whether the string is empty (i.e. whether its length is 0).
        
          ustring.push_back(value)
            Appends Unicode code value to the end of the string, increasing its length by one.
        
          ustring:resize(n, [value])
            Resizes the string to a length of n characters.

            If n is smaller than the current string length, the current value is shortened to its
            first n character, removing the characters beyond the nth.

            If n is greater than the current string length, the current content is extended by inserting 
            at the end as many characters as needed to reach a size of n.If the Unicode code "value" is specified, the new elements
            are initialized as copies of value, otherwise, they are U+0000.
          
          ustring:set(index, value)
            Set the character indicated by index to value.The value must be a Unicode code.
          
          ustring:size()
            Return the length of the string.
          
          ustring:sub(a, b)
            Returns the sub-ustring object that starts at a and continues until b.
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
    
    
    --copy the function member from fustring in order to avoid some problems of metatable
    for k, v in pairs(fustring) do
        self[k] = v;
    end
    
    --data initialization
    self.data = {};
    self.getchar = false;
    
    if(type(init_data) == "string") then
        self.data = ___ustring.Mb2UTF8t(init_data);
    elseif(type(init_data) == "table") then
        self.data = init_data;
    end
    
    self.length = #self.data;
    
    setmetatable(self, t);
end

function fustring:assign(d)
    self:clear();
    self.getchar = false;
    
    if(type(d) == "string") then
        self.data = ___ustring.Mb2UTF8t(d);
    elseif(type(d) == "table") then
        self.data = d;
    end
    
    self.length = #self.data;

end

function fustring:clear()
    self.data = {};
    self.length = 0;
    collectgarbage();
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

    return res;
end

function fustring:copy() -- copy constructor
    local res = ustring();
    for k, v in pairs(self.data) do
        table.insert(res.data, v);
    end
    res.getchar = self.getchar;
    res.length = self.length;
    
    return res;
end

function fustring:equal(b)
    if(type(b) == "number") then b = tostring(b); end 
    if(type(b) == "string") then b = ustring(b); end
    
    if(self.length ~= b.length) then return false; end
    
    for k, v in pairs(self.data) do
        if(v ~= b.data[k]) then 
            return false;
        end
    end
    
    return true;
end

function fustring:erase(a, b)
    if(self.data[a] == nil) then return nil; end
    
    if(b ~= nil) then
        if((self.data[b] == nil) or (a > b)) then return nil; end
        
        for i = a, b do
            table.remove(self.data, a);
        end
        self.length = self.length - (b - a + 1);
    else
        table.remove(self.data, a);
        self.length = self.length - 1;
    end
    
end

function fustring:find(str)
    if(type(str) == "string") then
        str = ustring(str);
    end
    
    if(
        (str.length > self.length) or
        (str.length == 0)
        )then 
        return nil;
    end
    local e = self.length - str.length;
    for i = 1, e do
        local f = true;
        for j = 1, str.length do
            if(str.data[j] ~= self.data[i + j - 1]) then 
                f = false;
                break;
            end
        end
        if(f) then
            return i, i + str.length - 1;
        end
    end
    return nil;
end

function fustring:get(index)
    if(self.data[index] == nil) then return nil; end
    if(self.getchar) then
        return string.uchar(self.data[index]);
    end
    
    return self.data[index];
end

function fustring:get_str()
    if(self:isempty()) then return "" end;
    local res = {};
    for k, v in pairs(self.data) do
        res[k] = string.uchar(v);
    end

    return table.concat(res);
end

function fustring:insert(str, index)
    if(type(str) == "number") then
          if((___ustring.checkUnicode(str)) and (self.data[index] ~= nil)) then
              table.insert(self.data, index, str)
              self.length = self.length + 1;
              return true;
          end
          return nil;
    elseif(type(str) == "string") then
          str = ustring(str);
    end
    if(str.length == 0) then return true; end
    for i = str.length, 1, -1 do
        table.insert(self.data, index, str.data[i]);
    end
    return true;
end


function fustring:isempty()
    if(self.length == 0) then
        return true;
    end
    return false;
end


function fustring:push_back(value)

    if(___ustring.checkUnicode(value) == false) then return nil; end
    self.length = self.length + 1;
    table.insert(self.data, value);
    
end

function fustring:resize(n, value)

    if(___ustring.checkN(n) == false) then return nil; end
    if(n == 0) then self:clear();return true; end
    if(value ~= nil) then
        if(___ustring.checkUnicode(value) == false) then return nil; end
    else
        value = 0;
    end
    
    if(n < self.length) then 
        for i = self.length, n + 1, -1 do
            table.remove(self.data);
        end
        self.length = n;
        collectgarbage();
        return true;
    end
   
    for i = self.length + 1, n do
        table.insert(self.data, value);
    end
    
    self.length = n;
    
    return true;
    
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


function fustring:size()
    return self.length;
end

function fustring:sub(a, b)
    if(a < 0) then a = self.length + a + 1; end
    if(b < 0) then b = self.length + b + 1; end
    
    if(
       (self.data[a] == nil) or 
       (self.data[b] == nil) or
       (a > b)) then
        return nil;
    end
    
    local res = ustring();
    res.getchar = self.getchar;
    
    for i = a, b do
        table.insert(res.data, self.data[i]);
    end
    
    res.length = b - a + 1;
    
    return res;
end

--private member, which begin with 3 underscores
___ustring = {};
___ustring.MN = {["Flag1"] = 0x80, ["Flag2"] = 0xC0, ["Flag3"] = 0xE0};
--[[
   Magic Number, this is used to recongize each bytes.
   U+0000 ~ U+007F use Flag1
   U+0080 ~ U+07FF use Flag2
   U+0800 ~ U+FFFF use Flag3
]]--

function ___ustring.checkN(n)
    if( (type(n) ~= "number") or ((math.ceil(n)) ~= n) or n < 0) then
        return false;
    end
    return true;
end

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
    local index, bytes = 1, #mbstr;
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
