//
//  03StringsAndCharacters.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/2/1.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

func stringAndCharacters() -> Void {
    /// 空字符串（两个等价）
    var emptyStr = ""
    var anotherEmpty = String()
    
    /// 字符串是值类型（不是引用）
    var hello = "hello"
    
    /// 在字符串遍历字符
    for c in hello.characters {
        print("hello: \(c)")
    }
    
    /// 字符数组定义
    let catCharacters: [Character] = ["C", "a", "b"]
    
    /// 字符串拼接
    var str1 = "aa"
    var str2 = "bb"
    var str3 = str1 + str2
    print("string3 = : \(str3)")
    str3 = str1.appending("cc")
    print("string3.appending: \(str3)")
    
    /// 字符串插值 构建新字符
    let multiplier = 3
    let message = "\(multiplier) times 2.5 is \(Double(multiplier)*2.5)"
    print("message字符串插值初始化:\(message)")
    
    /// 字符串字符数量
    // 因为swift支持Unicode(扩展群)的，所以数量和NSString的count数量可能不一致（UTF-16）
    // 当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16Count
    print("the number of hello: \(hello.characters.count)")
    
    /// 字符串下标索引（不是整数）
    // startIndex第一位；endIndex最后一位的下一位
    print("最后一个字符：\(hello[hello.index(before: hello.endIndex)])")
    print("第一个字符：\(hello[hello.startIndex])")
    print("第二个字符：\(hello[hello.index(after: hello.startIndex)])")
    // 偏移 .index(_:offsetBy:)
    print("第4个字符：\(hello[hello.index(hello.startIndex, offsetBy: 3)])")
    
    // .characters.indices 下标索引的范围range
    for index in hello.characters.indices {
        print("\(hello[index])", terminator:"")
    }
    print("")
    
    
    /// 插入
    // 制定位置插入一个字符
    hello.insert("!", at: hello.endIndex)
    print("hello.insert1: \(hello)")
    // insert(contentsOf:at:)在一个字符串的指定索引插入一段字符串
    // 插入字符集合 "xxx".characters
    hello.insert(contentsOf: " China".characters, at: hello.index(before: hello.endIndex))
    print("hello.insert2: \(hello)")
    
    /// 删除
    // 删除最后一位"!"
    hello.remove(at: hello.index(before: hello.endIndex))
    print("hello.remove1: \(hello)")
    
    var nonempty = "non-empty"
    if let i = nonempty.characters.index(of: "-") {
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
}


func unicodeTransform() -> Void {
    let dogString = "Dog‼🐶"
    
    /// utf-8
    print("utf-8:", terminator:" ")
    for codeUnit in dogString.utf8 {
        print("\(codeUnit)", terminator:" ")
    }
    print("")
    
    /// utf-16
    print("utf-16:", terminator:" ")
    for codeUnit in dogString.utf16 {
        print("\(codeUnit)", terminator:" ")
    }
    print("")
    
    /// unicode
    print("unicode(string):", terminator:" ")
    for scalar in dogString.unicodeScalars {
        print("\(scalar)", terminator:" ")
    }
    print("")
    print("unicode(value):", terminator:" ")
    for scalar in dogString.unicodeScalars {
        print("\(scalar.value)", terminator:" ")
    }
    print("")
}





