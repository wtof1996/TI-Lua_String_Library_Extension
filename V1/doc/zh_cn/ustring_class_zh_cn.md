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
			连接两个ustring对象
        ==    
			比较两个ustring对象是否相等
        tostring	
			tostring转换操作符，即可直接显式/隐式(e.g:用print直接输出)使用tostring转换成Lua内置的字符串类型
        
###公共成员###
      
####成员变量####
          ustring.data
				一个存储了ustring对象中所有字符的数组
          ustring.length
				ustring对象的长度(只能为从0开始的正整数，0表示当前ustring对象内容为空)
          ustring.getchar
				设置使用[]操作符或ustring.get返回值的类型是返回Unicode代码对应的字符还是直接返回Unicode代码
      
####成员函数####
          
          ustring(), ustring(<string>), ustring(<unicode table>)
				构造函数
 
          ustring:assign(<string>), ustring:assign(<unicode table>)
				重设ustring对象的内容

          ustring:clear()
          		清空一个ustring对象

          ustring:concat(<ustring>), ustring:concat(<string>), ustring:concat(<number>)
				连接两个ustring或者连接一个ustring对象与Lua内置的字符串或数字

          ustring:copy()
          		复制构造函数，通常复制ustring对象时应使用此函数而不是直接使用赋值操作以避免额外的影响

          ustring:erase(a, [b])
				删除指定位置或范围内的字符				

          ustring:equal(b)

          ustring:find(str)

          ustring:get(index)
        
          ustring:get_str()

          ustring:insert(str, index)

          ustring:isempty()
        
          ustring.push_back(value)

          ustring:resize(n, [value])
          
          ustring:sub(a, b)
            
          ustring:set(index, value)


##使用说明##

###操作符###
      	[] 
        .. 
        == 
        tostring
        
###公共成员###
      
####成员变量####

**P.S: It's hard to implement the read-only member, so BE CAREFUL when you use the "data" and "length" member.**
          
#####ustring.data#####
              An array that contains the sequence of characters that make up the value of the string object.
              Please DO NOT modify or overwrite this member! You should use the member functions to do the work.
          
#####ustring.length#####
              The length of the string (i.e. the number of characters).
              Please DO NOT modify or overwrite this member! You should use the member functions to do the work.
          
#####ustring.getchar#####
              A boolean value indicates the return value type of ustring.get and the "[]" operator
             (only for the indexing access). If it is true, it will return a character, or it will return a Unicode code.
             The default value is false.
      
####成员函数####
          
#####构造函数#####
*ustring(), ustring(/string/), ustring(/unicode table/)*

            The construct function.
 
#####ustring:assign(<string>), ustring:assign(<unicode table>)#####
            Assign content to the string object.

#####ustring:clear()#####
            Clear the content of the string object.
          
#####ustring:concat(<ustring>), ustring:concat(<string>), ustring:concat(<number>)#####

            Concat two string object or string.If input is a number, the number will be convert into a string object.
            The operator ".." is overloaded from this function.
          
#####ustring:copy()#####
            The copy constructor, return a copy form the string object.
          
#####ustring:erase(a, [b])#####
            Erases part of the string object, reducing its length.
            If b is not specificed, the character at position a will be erased; Otherwise this erases the sequence 
            of characters in the range [a, b].
            
#####ustring:equal(b)#####
            Test if the string object is equal to string object b.
            The operator "==" is overloaded from this function.
            
#####ustring:find(str)#####
            Find content str in the string object. If it finds a match, the function returns the first index of str where this occurrence 
            starts and ends; otherwise, it returns nil. This uses "Naive string search algorithm", so the asymptotic time complexity is O(mn).
          
#####ustring:get(index)#####
            Get a character form the string object. The return value depends on ustring.getchar.
            The indexing access operator "[]" overloaded from this function.
        
#####ustring:get_str()#####
            Returns a Lua orginal string in UTF8 encode which contains a sequence of characters 
            that make up the value of the string object.
        
#####ustring:insert(str, index)#####
            Inserts additional characters into the string object before the character indicated by index.
        
#####ustring:isempty()#####
            Returns whether the string is empty (i.e. whether its length is 0).
        
#####ustring.push_back(value)#####
            Appends Unicode code value to the end of the string, increasing its length by one.
        
#####ustring:resize(n, [value])#####
            Resizes the string to a length of n characters.

            If n is smaller than the current string length, the current value is shortened to its
            first n character, removing the characters beyond the nth.

            If n is greater than the current string length, the current content is extended by inserting 
            at the end as many characters as needed to reach a size of n.If the Unicode code "value" is specified, the new elements
            are initialized as copies of value, otherwise, they are U+0000.
          
#####ustring:sub(a, b)#####
            Returns the substring object that starts at a and continues until b.
            
#####ustring:set(index, value)#####
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

P.S：若使用本库请在你的源代码中保留上述信息或在关于信息中注明上述信息(若太长可做简单标注，但要求能体现作者、名称、许可等主要信息，如:"使用了wtof1996 编写的TI-Lua String Library Extension库(简写为SLE也可以)，此库按 Apache 2.0许可进行授权")
	

##作者信息##

版本:V1.00

设计&开发:wtof1996

英文校对:chsi

参与测试:

Email: wtof1996 at gmail.com

BUG&建议请一律发送至上述Email，欢迎提交。