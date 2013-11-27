--[[
    #FreInclude <ctype\ctype_assert.lua>
]]--

print(tostring(assert(ctype.isalnum("Z"))));
print(tostring(assert(ctype.islower("Z"))));
print(tostring(assert(ctype.isupper("Z"))));
print(tostring(assert(ctype.isxdigit("A"))));
print(tostring(assert(ctype.isprint("Z"))));
