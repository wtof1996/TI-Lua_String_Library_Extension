#TI-Lua String Library Extension#
#ustring class库使用说明#

##简介##

此库提供了一个类似C++中string的字符串类，同时也支持Lua原生字符串中的大多数用法，可以很方便的实现UTF8字符串间的连接，查找，比较，截取，随机访问等。
出于兼容性的考虑，这个类目前并不提供异常机制。

##成员列表##

###操作符###
        [] 
			读取/修改指定位置的字符(位置从1开始计数)
        .. 	
			连接两个ustring或者连接一个ustring对象与Lua内置的字符串或数字
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
				连接两个ustring或者连接一个ustring对象与Lua内置的字符串或数字

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
				在当前ustring对象的index位置插入str

          ustring:isempty()
				测试ustring对象是否为空
        
          ustring.push_back(value)
				将Unicode代码为value的字符添加到ustring对象末尾

          ustring:resize(n, [value])
				重设ustring对象的大小
          
          ustring:sub(a, b)
				截取ustring对象从位置a到b的部分
            
          ustring:set(index, value)
				设置index位置的字符Unicode代码为value


##使用说明##

**P.S:**

**1.由于TI-LUA的限制，此库仅能处理U+0000~U+FFFF范围内的字符，所以一个UTF8字符最多需要3字节的空间。**

**2.由于此类库设计上是从整体上设计的，因此建议保留全部代码。但是从设计时就最大程度上降低了耦合性，因此如的确需要，请酌情精简公共成员中的某些成员函数，切勿精简任何私有成员(注释"private member, which begin with 3 underscores"后的部分)！！！**

**3.由于只读成员的实现十分困难，因此在使用ustring.data或ustring.length成员时请务必小心，避免直接对其进行修改。**

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
**使用此成员时请确保仅进行读取操作，任何对ustring对象长度的修改应该通过成员函数进行而不是直接修改此成员！**
          
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
          
#####构造函数#####

#####ustring(), ustring(/string/), ustring(/unicode table/)#####

* **形参列表:**
		<nil> 	即形参为空，此时为默认构造函数，返回一个空的ustring对象
		<string>即使用Lua内置字符串类型作为初值
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
* **返回值列表:**
* **e.g:**    
			Assign content to the string object.

#####ustring:clear()#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Clear the content of the string object.
          
#####ustring:concat(<ustring>), ustring:concat(<string>), ustring:concat(<number>)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Concat two string object or string.If input is a number, the number will be convert into a string object.
            The operator ".." is overloaded from this function.
          
#####ustring:copy()#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            The copy constructor, return a copy form the string object.
          
#####ustring:erase(a, [b])#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Erases part of the string object, reducing its length.
            If b is not specificed, the character at position a will be erased; Otherwise this erases the sequence 
            of characters in the range [a, b].
            
#####ustring:equal(b)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Test if the string object is equal to string object b.
            The operator "==" is overloaded from this function.
            
#####ustring:find(str)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Find content str in the string object. If it finds a match, the function returns the first index of str where this occurrence 
            starts and ends; otherwise, it returns nil. This uses "Naive string search algorithm", so the asymptotic time complexity is O(mn).
          
#####ustring:get(index)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Get a character form the string object. The return value depends on ustring.getchar.
            The indexing access operator "[]" overloaded from this function.
        
#####ustring:get_str()#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Returns a Lua orginal string in UTF8 encode which contains a sequence of characters 
            that make up the value of the string object.
        
#####ustring:insert(str, index)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Inserts additional characters into the string object before the character indicated by index.
        
#####ustring:isempty()#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Returns whether the string is empty (i.e. whether its length is 0).
        
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
          
#####ustring:sub(a, b)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Returns the substring object that starts at a and continues until b.
            
#####ustring:set(index, value)#####

* **形参列表:**
* **返回值列表:**
* **e.g:**
            Set the character indicated by index to value.The value must be a Unicode code.

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