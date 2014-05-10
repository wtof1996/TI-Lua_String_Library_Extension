#TI-Lua String Library Extension#
#ustring class库使用说明#

##简介##

此库提供了一个类似C++中string的动态字符串类，同时也支持Lua原生字符串中的大多数用法，可以很方便的实现UTF8字符串间的连接，查找，比较，截取，插入，删除以及随机访问等操作。
出于兼容性的考虑，这个类目前并不提供异常机制。

##成员列表##

###操作符###
        [] 
			读取/修改指定位置的字符(位置从1开始计数)
        .. 	
			将一个ustring对象与一个Lua内置字符串或数字或另一个ustring对象连接
        ==    
			比较两个ustring对象是否相等
        tostring	
			tostring转换操作符，即可直接显式/隐式(e.g:用print直接输出)使用tostring转换成Lua内置的字符串类型
        
###公共成员###
      
####成员变量####
          ustring.data
				一个存储了ustring对象中所有字符的数组
          ustring.length
				ustring对象的长度(即Unicode字符的数量，只能为从0开始的正整数，0表示当前ustring对象内容为空)
          ustring.getchar
				Boolean类型，设置使用[]操作符或ustring.get返回值的类型是返回Unicode代码对应的字符还是直接返回Unicode代码
      
####成员函数####
          
          ustring(), ustring(<string>), ustring(<unicode table>)
				构造函数
 
          ustring:assign(<string>), ustring:assign(<unicode table>)
				重设ustring对象的内容

          ustring:clear()
          		清空ustring对象

          ustring:concat(<ustring>), ustring:concat(<string>), ustring:concat(<number>)
				将一个ustring对象与一个Lua内置字符串或数字或另一个ustring对象连接

          ustring:copy()
          		复制构造函数，通常复制ustring对象时应使用此函数而不是直接使用赋值操作以避免额外的影响

          ustring:erase(a, [b])
				删除指定位置或范围内的字符	

          ustring:equal(b)
				比较两个ustring对象是否相等

          ustring:find(str)
				使用朴素字符串查找算法搜索str首次出现的位置

          ustring:get(index)
				返回index位置的字符的Unicode代码或字符本身(视ustring.getchar的设置情况而定)
        
          ustring:get_str()
				将ustring对象转换为Lua内置字符串类型

          ustring:insert(str, index)
				在当前ustring对象的index位置之前插入str

          ustring:isempty()
				测试ustring对象是否为空
        
          ustring.push_back(value)
				将Unicode代码为value的字符添加到ustring对象末尾

          ustring:resize(n, [value])
				重设ustring对象的大小

          ustring:set(index, value)
				设置index位置的字符Unicode代码为value

		  ustring:size()
				获取ustring对象的长度
			
          ustring:sub(a, b)
				截取ustring对象从位置a到b的部分

##使用说明##

**N.B:**

**1.由于TI-LUA的限制，此库仅能处理U+0000~U+FFFF范围内的字符，所以一个UTF8字符最多需要3字节的空间。**

**2.由于此类库设计上是从整体上设计的，因此建议保留全部代码。但是从设计时就最大程度上降低了耦合性，因此如的确需要，请酌情精简公共成员中的某些成员函数，切勿精简任何私有成员(注释"private member, which begin with 3 underscores"后的部分)！！！**

**3.由于只读成员的实现十分困难，因此在使用ustring.data或ustring.length成员时请务必小心，避免直接对其进行修改。同时，大部分操作均可通过相应的成员函数实现，因此一般情况下不应该直接使用这两个成员变量！**

###操作符###

####a[index], a[index] = value####

读取/修改a中位于index的字符**(位置从1开始计数)**。

本操作符实质上相当于调用了a:get(index)或a:set(index, value)。

* **e.g:**

> a[1] = 27979  
> --修改a中第一个字符为"测"
> 
> print(a[1])  
> --打印a中第一个字符(显示"27979"还是"测"视ustring.getchar的设置情况而定)

####a .. b####

连接两个ustring或者连接一个ustring对象与Lua内置的字符串或数字，如果a或b中有一个不是ustring对象那么会自动转换为ustring对象(number会先转换为string然后利用构造函数构造ustring对象)。**使用本操作符最终结果一定是ustring对象。**

本操作符实质上相当于调用了ustring.concat(a, b)。

* **e.g:** 
 
> a = ustring("123")
> 
> b = ustring("测试")
> 
> c = a .. b
> 
> print(c)  
> --输出 "123测试"

####a == b####

比较a和b是否相等。**需要注意的是，由于==操作符在比较系统内置类型时会先判断两边类型是否一致，因此本操作符仅能用于比较ustring对象。**

本操作符实际上相当于调用了a:equal(b)。

* **e.g:**

> a = ustring("233")
> 
> b = ustring("233")
> 
> c = ustring("test")
> 
> print(a == b, a == c)  
> --输出true	  false

####tostring(a)####

tostring转换操作符，即可直接显式/隐式使用tostring将ustring对象a转换成Lua内置的字符串类型

本操作符等价于调用了a:get_str()

* **e.g:**

> a = ustring("123")
> 
> print(a)  
> --输出123

###公共成员###
      
####成员变量####

#####ustring.data#####

一个存储了ustring对象中所有字符的数组，是整个ustring对象的基础，可以类比C中的char数组。
**请不要直接修改此成员，而是通过ustring类的相关成员函数进行修改！**
          
#####ustring.length#####

表示ustring对象的长度(即Unicode字符的数量，只能为从0开始的正整数，0表示当前ustring对象内容为空)。
**使用此成员时请确保仅进行读取操作，任何对ustring对象长度的修改应该通过成员函数进行而不是直接修改此成员！强烈建议使用ustring:size()获取长度而不是直接读取此成员！**
          
#####ustring.getchar#####

Boolean类型，设置使用[]操作符或ustring.get返回值的类型是返回Unicode代码对应的字符还是直接返回Unicode代码。
此成员设置为true时表示返回字符，false表示返回Unicode代码。**默认为flase。**

* **e.g:**

> a = ustring("测试")
> 
> print(a[2])  
> --输出 35797
> 
> a.getchar = true
> 
> print(a[2])  
> --输出 试
      
####成员函数####
          

#####ustring(), ustring(/string/), ustring(/unicode table/)#####

* **形参列表:**
		<nil>           即形参为空，此时为默认构造函数，返回一个空的ustring对象
		<string>		即使用Lua内置字符串类型作为初值
		<unicode table> 使用一个含有Unicode代码的Table作为初值
* **返回值列表:**
		 ustring		即构造好的ustring对象

最基本的构造函数，用于构造ustring对象。
默认构造函数将采用如下设置:
> **self.data = {}**
> **self.getchar = false**
> **self.length = 0**

若形参不为nil那么data和length会根据输入数据进行调整，**但是getchar成员仍然为false**。

* **e.g:**

> a = ustring()  
> --空ustring对象
> b = ustring("Hello World~")  
> --内容为"Hello world~"的ustring对象
> c = ustring({72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 126})
> --等同于b
> d = ustring("中文测试")  
> --内容为"中文测试"的ustring对象
> e = ustring({20013, 25991, 27979, 35797})
> --等同于d
 
#####ustring:assign(/string/), ustring:assign(/unicode table/)#####

* **形参列表:**
		<string>		即使用Lua内置字符串类型作为新的内容
		<unicode table> 使用一个含有Unicode代码的Table作为新的内容

重设ustring对象的内容。
* **e.g:**    
> a = ustring("Test")
> print(a)
> --输出 "Test"
> a:assign("Another String")
> print(a)
> --输出 "Another String"
> a:assign({20013, 25991, 27979, 35797})
> print(a)
> --输出 "中文测试"


#####ustring:clear()#####

清空整个ustring对象，其长度将置为0。

          
#####ustring:concat(/ustring/), ustring:concat(/string/), ustring:concat(/number/)#####

* **形参列表:**
		<ustring>  要连接的ustring对象
		<string>   要连接Lua内置字符串
		<number>   要连接的数字
* **返回值列表:**
		res		   连接后的ustring对象
将一个ustring对象与一个Lua内置字符串或数字或另一个ustring对象连接。
如果参数不是ustring对象那么会自动转换为ustring对象(number会先转换为string然后利用构造函数构造ustring对象)。

N.B:由于返回的是一个临时的ustring对象，故可以连续调用此成员函数。

* **e.g:**

> a = ustring("测试");
> b = ustring("test");
> c = 123;
> d = "another test";
> e = a:concat(b):concat(c):concat(d);
> print(e);	
> --输出  "测试test123another test"

          
#####ustring:copy()#####

* **返回值列表:**
	res		当前ustring对象的一个副本

生成当前的ustring对象的一个副本，即复制构造函数。

**强烈建议使用此函数进行ustring对象的复制而不是直接赋值，以免对直接赋值后的对象进行的修改影响到原来的对象！！！(具体原因可参考下面的样例)**

* **e.g:**

> a = ustring("Reference")
> b = ustring("No Reference")

> c = b:copy()
> d = a
> d:insert("test", 1)
> c:insert("test", 1)
> --在c和d开头插入字符串 test
> print(a, d)
> --输出 "testReference	testReference"
> print(b, c)
> --输出"No Reference 	testNo Reference"
> 
> --显然，在没有使用复制构造函数的情况下，直接赋值类似于C++中引用的行为。


#####ustring:erase(a, [b])#####

* **形参列表:**
		a		想要删除的字符的位置或者是想要删除的区间的开始位置
	    [b]	  如果指定了此参数那么会删除[a, b]范围内的全部字符

删除ustring对象的一部分字符并减少其长度。
如果未指明参数b那么仅删除位于位置a的字符，否则会删除[a, b]范围内的全部字符。

* **e.g:**
> a = ustring("A string for test")
> a:erase(1)
> print(a)
> --输出 " string for test"
> a:erase(1, 7)
> print(a)
> --输出 " for test"

#####ustring:equal(b)#####

* **形参列表:**
		b		想要比较的ustring对象
* **返回值列表:**
		res 	一个Boolean值，表示比较的结果。相同为true，否则为false
比较ustring对象b是否与当前ustring对象相等。
与==操作符不同的是，若b为number或者string类型时，会先将其转换为ustring对象然后比较(number会先转换为string然后利用构造函数构造ustring对象)。
* **e.g:**
> a = ustring("string")
> b = ustring("test")
> print(a:equal(b), a:equal("string"))
> --输出false	true

#####ustring:find(str)#####

* **形参列表:**
		str		想要查找的ustring对象或者普通的string
* **返回值列表:**
		a, b		查找的结果，找到则为str第一次出现和结束的位置
		nil		 未找到
在当前ustring对象中查找str，若str是string则会将其转换为ustring对象。
如果找到则返回str第一次出现的位置和结束，否则返回nil。
此成员函数使用的是朴素字符串查找算法(Naive string search algorithm),渐进时间复杂度为O(mn)，对于很长的字符串可能需要较大的时间代价。

**此成员函数不支持正则表达式！**
* **e.g:**
> a = ustring("This is a ustring object in TI-Lua.这是一个测试字符串")
> b = ustring("测试")
> print(a:find(b))
> --输出	40	41
> print(a:find("object"))
> --输出19	24


#####ustring:get(index)#####

* **形参列表:**
		index		想要读取的字符索引
* **返回值列表:**
		res			读取的字符Unicode值或字符本身(取决于ustring.getchar的值)
读取位于index的字符**(位置从1开始计数)**。
若getchar成员的值为true则返回字符，否则返回Unicode代码(默认false)。

        
#####ustring:get_str()#####

* **返回值列表:**
		res		与当前ustring内容相同的Lua内置类型字符串

返回一个与当前ustring内容相同的Lua内置类型字符串。

#####ustring:insert(str, index)#####

* **形参列表:**
		str		想要插入的内容，可以是一个Unicode代码，一个ustring对象或者是Lua内置类型字符串
		index	  想要插入的位置，会在此位置之前插入内容

在index位置**之前**插入内容。
**index的取值范围为[1, ustring:size() + 1]**。当index为ustring:size() + 1时表示在末尾插入字符串。
当str为数字时会认为是一个Unicode代码，若为ustring对象或者是Lua内置类型字符串时会取其中的内容进行插入。

* **e.g:**
> a = ustring("Test")
> b = a:copy()
> c = ustring();
> a:insert(27979, 1)
> b:insert("Another Test ", 5)
> c:insert(b, 1)
> print(a, b, c)
> --输出 测Test	TestAnother Test 	TestAnother Test 
        
#####ustring:isempty()#####

* **返回值列表:**
			res 	一个Boolean值，若当前ustring对象是空的则为true，否则为false
测试当前ustring对象是否为空(即长度为0)。
        
#####ustring.push_back(value)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Appends Unicode code value to the end of the string, increasing its length by one.
        
#####ustring:resize(n, [value])#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Resizes the string to a length of n characters.

            If n is smaller than the current string length, the current value is shortened to its
            first n character, removing the characters beyond the nth.

            If n is greater than the current string length, the current content is extended by inserting 
            at the end as many characters as needed to reach a size of n.If the Unicode code "value" is specified, the new elements
            are initialized as copies of value, otherwise, they are U+0000.
          
#####ustring:set(index, value)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Set the character indicated by index to value.The value must be a Unicode code.

#####ustring:size()#####

* **返回值列表:**
 		length		当前ustring对象的长度
获取当前ustring对象的长度。

#####ustring:sub(a, b)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Returns the substring object that starts at a and continues until b.
            


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

**P.S：若使用本库请在你的源代码中保留上述信息或在关于信息中注明上述信息(若太长可做简单标注，但要求能体现作者、名称、许可等主要信息，如:** 

> **"使用了wtof1996 编写的TI-Lua String Library Extension库(简写为SLE也可以)，此库按 Apache 2.0许可进行授权)"**
	

##作者信息##

版本:V1.00

设计&开发:wtof1996

英文校对:chsi

参与测试:

Email: wtof1996 at gmail.com

BUG&建议请一律发送至上述Email，欢迎提交。