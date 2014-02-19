#TI-Lua String Library Extension#
#ctype库使用说明#

##简介##

这个库用于单个ASCII字符处理，功能与C语言中的 ctype.h 库一致。

这个库有两个版本:assert版和非assert版。assert版支持使用assert函数进行错误处理，但表示真假的返回值为0(false)或1(true)。非assert版不支持assert函数但表示真假的返回值是true或false。

##成员列表##

assert版和非assert版均具有以下函数/异常(函数功能均与C语言中的 ctype.h 库一致,此处不再赘述):

* 异常列表:

			
			ctype.exception.invChar		--输入字符非法
			ctype.exception.invType		--输入数据类型非法
			ctype.exception.longString  --输入不是单个ASCII字符

* 测试函数:
            
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

* 转换函数:
* 
            ctype.tolower(char)
            ctype.toupper(char)

##使用说明##

###非assert版###

每个函数均会返回2个值，第一个为结果(下文简称res)，第二个为错误信息(下文简称err)。

对于测试函数来说，res可以是true，false或者nil(此时表示出现错误)，而对于转换函数来说，res可以是转换后的结果(注意转换函数总是返回数值而不是对应的字符)或者是nil(此时表示出现错误)。两种函数的err含义均相同，可以是nil(无错)或者是对应的错误信息。

此版本的使用可参考样例/samples/ctype_sample_non_assert.lua

###assert版###

每个函数均会返回2个值，第一个为结果(下文简称res)，第二个为错误信息(下文简称err)。

对于测试函数来说，res可以是1(相当于true)，0(相当于false)或者nil(此时表示出现错误)，而对于转换函数来说，res可以是转换后的结果(注意转换函数总是返回数值而不是对应的字符)或者是nil(此时表示出现错误)。两种函数的err含义均相同，可以是nil(无错)或者是对应的错误信息。

如果你的TI-Lua脚本中设计了错误处理函数(即设置了platform.registerErrorHandler)，强烈建议配合assert函数来使用本库的函数，比如说这样:

	test_result = assert(isnumber("1"));
如果出现异常那么assert会自动引发一个错误(不需要你自己去检查err了)，然后你就可以通过错误处理函数作进一步处理(可参考样例/samples/ctype_sample_assert.lua)。

**P.S:此功能需要API 2.0或更高版本**

同时为了避免Magic Number，你还可以使用ctype["true"]代替1，ctype["false"]代替0，就像这样:
	
	...
	local res = assert(ctype.isalpha("a"));

    if(res == ctype["true"]) then
         ...
    end
	...
P.S:使用数字代替true/false是因为如果通过assert调用函数返回的第一个参数为false的话，就会直接引发一个错误。

##版权信息##

    TI-Lua String Library Extension
 	Copyright 2014 wtof1996
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

P.S：若使用本库请在你的源代码中保留上述信息或在关于信息中注明上述信息(若太长可做简单标注，但要求能体现作者、名称、许可等主要信息，如:"使用了wtof1996 编写的TI-Lua String Library Extension库，此库按 Apache 2.0许可进行授权")
	

##作者信息##

设计&开发:wtof1996

英文校对:chsi

参与测试:

Email: wtof1996 at gmail.com

BUG&建议请一律发送至上述Email，欢迎提交。