//
//  03StringsAndCharacters.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/2/1.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

func stringAndCharacters() -> Void {
    /// 空字符串（两个等价）
    var emptyStr = ""
    var anotherEmpty = String()

    /// 多行字符串定义
    // """包裹
    // 可以用在行尾写一个反斜杠（\）作为续行符，不会生成换行符
    let quotation1 = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""

    // 最后一个"""起到对齐作用，Begin和"""相比落后4个空格，所以只有Begin前面有空格
    // 其他行前面没有空格，因为最后一个"""前面的空格都会被忽略
    let quotation2 = """
    The White Rabbit put on his spectacles.  "Where shall I begin,
    please your Majesty?" he asked.

        "Begin at the beginning," the King said gravely, "and go on
    till you come to the end; then stop."
    Escaping the first quote
    """
    
    // 第一个"""之后不会换行，最后一个"""之前不会换行，以下两个字符串相等
    let singleLineString = "These are the same."
    let multilineString = """
    These are the same.
    """
    
    // 转义 """
    let threeDoubleQuotes = """
    Escaping the first quote \"\"\"
    Escaping all three quotes \"\"\"
    """
    
    // 扩展字符串分隔符: 直接包含而非转义
    // \n 直接当字符传输入，不会换行
    // 需要换行加 \#n
    let signleline = #"Line 1 \nLine 2"#
    let threeMoreDoubleQuotationMarks = #"""
    Here are three more double quotes: """\n
    """#
    
    /// 字符串是值类型（不是引用）
    var hello = "hello"
    
    /// 在字符串遍历字符
    for character in hello {
        print("hello: \(character)")
    }
    
    /// 字符数组定义
    let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
    let catString = String(catCharacters)
    print(catString) // 打印输出：“Cat!🐱”

    /// 字面量定义
    let wiseWords = "\0"    // \0：空字符
    let haert = "\u{1F496}"  // "💖"

    /// 字符串拼接
    var str1 = "aa"
    var str2 = "bb"
    var str3 = str1 + str2
    print("string3 = : \(str3)") // string3 = : aabb
    // appending 追加生成新字符串
    str3 = str1.appending("cc")
    print("string3.appending: \(str3)") // string3.appending: aacc
    // append 直接修改当前字符串
    str3.append("dd")
    print("string3.append: \(str3)") // string3.append: aaccdd
    
    /// 字符串插值 构建新字符
    let multiplier = 3
    let message = "\(multiplier) times 2.5 is \(Double(multiplier)*2.5)"
    print("message字符串插值初始化:\(message)")
    // 插值失效
    // 改为 `\#(multiplier)` 会继续生效
    print(#"Write an interpolated string in Swift using \(multiplier)."#)
    
    /// 字符串字符数量
    // 因为swift支持Unicode(扩展群)的，所以数量和NSString的count数量可能不一致（UTF-16）
    // 当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16Count
    print("the number of hello: \(hello.count)")

    /// 扩展字形集群
    // é可以由单个 Unicode 标量 é ( LATIN SMALL LETTER E WITH ACUTE, 或者 U+00E9)表示，也可以由 e( LATIN SMALL LETTER E,或者说  U+0065)，以及 COMBINING ACUTE ACCENT标量( U+0301)表示，实际个数依然是1个
    var word = "cafe"
    print("the number of characters in \(word) is \(word.count)") // Prints "the number of characters in cafe is 4"

    word += "\u{301}"    // COMBINING ACUTE ACCENT, U+030
    print("the number of characters in \(word) is \(word.count)") // Prints "the number of characters in café is 4"
    
    /// 字符串下标索引（不是整数）
    // startIndex第一位；endIndex最后一位的下一位
    print("最后一个字符：\(hello[hello.index(before: hello.endIndex)])")
    print("第一个字符：\(hello[hello.startIndex])")
    print("第二个字符：\(hello[hello.index(after: hello.startIndex)])")
    // 偏移 .index(_:offsetBy:)，超出范围 crah （bad_access）
    print("第4个字符：\(hello[hello.index(hello.startIndex, offsetBy: 3)])")
    // 带有限制的偏移，超出限制 返回nil
    print("第4个字符：\(hello.index(hello.startIndex, offsetBy: 100, limitedBy: hello.endIndex))")
    
    // .indices 下标索引的范围range
    for index in hello.indices {
        print("\(hello[index])", terminator:"")
    }
    print("")

    // **************************************************************************************
    // 可以在任何遵循了 Indexable 协议的类型中使用 startIndex 和 endIndex 属性以及 index(before:) ， index(after:) 和 index(_:offsetBy:) 方法。这包括这里使用的 String ，还有集合类型比如 Array ， Dictionary 和 Set 。
    // **************************************************************************************

    /// 插入
    // 指定位置插入一个字符
    hello.insert("!", at: hello.endIndex)
    print("hello.insert1: \(hello)")    // //  "hello!"

    // insert(contentsOf:at:)在一个字符串的指定索引插入一段字符串
    // 插入字符集合 "xxx".characters
    hello.insert(contentsOf: " China", at: hello.index(before: hello.endIndex))
    print("hello.insert2: \(hello)")    //  "hello China!"
    
    /// 删除
    // 删除最后一位"!"
    hello.remove(at: hello.index(before: hello.endIndex))
    print("hello.remove1: \(hello)")
    
    var nonempty = "non-empty"
    if let i = nonempty.firstIndex(of: "-") {
        nonempty.remove(at: i)
    }
    print(nonempty)
    
    // 删除" china"
    let range = hello.index(hello.endIndex, offsetBy: -6) ..< hello.endIndex
    hello.removeSubrange(range)
    print("hello.remove2: \(hello)")
    
    /// 字符串相等
    // 相等 ==  ，不等 !=
    // 可扩展的字形群集 即使有不同的Unicode标量构成，只要他们有同样的语言意义和外观，就认为他们标准相等
    let equalSample1 = "aa"
    let equalSample2 = "aa"
    if equalSample1 == equalSample2 {
        print("equalSample1 is equals to equalSample2")
    }
    
    
    /// 前后缀
    if hello.hasPrefix("he") {
        print("hello 有前缀 'he'")
    }
    if hello.hasSuffix("lo") {
        print("hello 有后缀 'lo'")
    }

    
    
    /// 字符串切片 substring
    // substring 和 原 string 共享内存
    let greeting = "Hello, world!"
    let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
    let beginning = greeting[..<index] // beginning 的值为 "Hello"
    // 把结果转化为 String 以便长期存储。（和原 string 不再共享内存）
    let newString = String(beginning)
    
    /// hasSuffix / hasPrefix
    let mixStr = "Swift 3.0 is interesting!"
    if mixStr.hasSuffix("Swift") {
        print("has suffix")
    }
    
    /// 截取前后 字符串的 【substring】
    hello.prefix(2)
    hello.suffix(2)
    let swiftView = mixStr.suffix(12).dropLast()
    // 先用suffix截掉了头部的"Swift 3.0 is"，再用dropLast方法去掉了末尾的“!”
    // 此时，对mixStr.characters的操作，得到的是一个String.CharacterView对象，需要用这个view，生成一个新的String
    String(swiftView) // swiftView = interesting
    let strViews = mixStr.split(separator: " ") // String.CharacterView集合
    
    // 用map方法把每集合中的每一个view都生成一个新的String对象，最后，就得到了一个包含每一个子串的数组Array<String>
    let strList = strViews.map(String.init) // // ["Swift", "3.0", "is", "interesting!"]
    print(strViews)
    print(strList)
    
    /// 使用closure来分割
    // 按空格分隔单词
    var i = 0
    let singleCharViews = mixStr.split { (c) -> Bool in
        switch c {
        case " ":
            i = 0
            return true
        default:
            i += 1
            return false
        }
    }
    
    singleCharViews.map(String.init)
    // ["Swift", "3.0", "is", "interesting!"]

    /// 遍历
    for (i, c) in hello.enumerated() {
        print("\(i): \(c)")
    }
}


func unicodeTransform() -> Void {
    let dogString = "Dog‼🐶"
    
    /// utf-8
    print("utf-8:", terminator:" ")
    for codeUnit in dogString.utf8 {
        print("\(codeUnit)", terminator:" ")
    }
    print("")
    // 68 111 103 226 128 188 240 159 144 182
    
    /// utf-16
    print("utf-16:", terminator:" ")
    for codeUnit in dogString.utf16 {
        print("\(codeUnit)", terminator:" ")
    }
    print("")
    // 68 111 103 8252 55357 56374
    
    /// unicode
    print("unicode(string):", terminator:" ")
    for scalar in dogString.unicodeScalars {
        print("\(scalar)", terminator:"")
    }
    print("")
    // Dog‼🐶
    
    print("unicode(value):", terminator:" ")
    for scalar in dogString.unicodeScalars {
        print("\(scalar.value)", terminator:" ")
    }
    print("")
    // 68 111 103 8252 128054
    
    /// 加载emoji, 需要{}包裹
    let emoji = "\u{1F4C4}"
}

// mark - swift5
func stringSwift5() {
    /// 更强大的 Raw String
    let qutoedStr = #"有"双引号"可以不用转义"#
    // 输出： 有"双引号"可以不用转义
    
    let escapeStr = #"有\转义符号反斜杆\可以不用转义"#
    // 输出： 有\转义符号反斜杆\可以不用转义
    
    /// 字符串转义 需要修改 \#(variable)
    let newEscapeStr = #"\"#
    let newStr = #"加载变量：有\#(newEscapeStr)反斜杠转义符\#(newEscapeStr)"#
    // 输出：加载变量：有\反斜杠转义符\
    
    /// 多行
    let multiLineText = #"""
    "\"
    ''''
    正常显示
    """#
    
    /// 字符串中有 "#
    let doubleHashStr = ##"字符串内有"# 使用双#包括"##
    
    /// 优雅的正则表达式
    let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
    let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
}

/// 让String支持下标操作(不可取)
// *** 但是该方法是O(n^2)的，容易造成性能隐患
// 让String支持[]并不是一个好主意
extension String {
    subscript(index: Int) -> Character {
        guard let index = self.index(startIndex, offsetBy: index, limitedBy: endIndex) else {
            fatalError("String index out of range.")
        }
        
        return self[index]
    }
}



