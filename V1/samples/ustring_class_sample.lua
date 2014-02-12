--[[
    #FreInclude <ustring\class\ustring_c.lua>
]]--

--[[
    This is a simple sample which shows how to use ustring class lib.
    You'd better use this with iLua.
]]--


test_u_table = {20013,25991,27979,35797};
test_u_string = string.uchar(20013,25991,27979,35797);

a = ustring(test_u_table);
b = ustring(test_u_string);

print(a, a.length);
print(a == b);

c = a:copy();
c = "Chinese Test" .." " .. c .. 123;
print(c);

target = string.uchar(27979, 35797);
s, e = c:find(target) ;
c:erase(s, e);
s, e = c:find("Test");
d = c:sub(s, e);
print(c, d);

c.getchar = true;
print(c[1]);

c:push_back(24456);c:push_back(22909);
c[1], c[2] = 24456, 22909;
print(c);

c:resize(2);
print(c);

a:insert(tostring(c), 2);
print(a);

c:resize(10, 23545);
print(c);
c:clear();

b:assign("wtof1996");
print(b);
