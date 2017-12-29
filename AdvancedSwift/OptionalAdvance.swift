//
//  OptionalAdvance.swift
//  SwiftTutorial
//
//  Created by daoquan on 2017/12/26.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/*
 可选型 定义（一个枚举）：
 
 enum Optional<Wrapped> {
    case none
    case some(wrapped)
 }
 */
func optionalAdvance() {
    var array = ["one", "two", "three"]
    switch array.index(of: "four") {
    case .some(let idx): array.remove(at: idx)
    case .none: print("idx is null")
    }
    
    switch array.index(of: "four") {
    case let idx?: array.remove(at: idx)
    case nil: print("idx is null")
    }
    
    /// 针对Optional<Optional<Int>>
    let stringNumbers = ["1", "2", "three"]
    let maybeInts = stringNumbers.map { Int($0) }   // Optional<Int>数组
    for maybeInt in maybeInts {
        // maybeInt 是一个 Int? 值
        // 得到两个整数值和一个 `nil`
        print(maybeInt, terminator: " ")    // Optional(1) Optional(2) nil
    }
    
    // for...in是while循环加上一个迭代器
    var iterator = maybeInts.makeIterator()
    // next()返回的是Optional<Optional<Int>>
    // 所以最后一个 some(nil) 也会进入while循环
    while let maybeInt = iterator.next() {
        print(maybeInt)     //Optional(1) Optional(2) nil
    }

    // 使用if case，取出非nil的值
    // i? 处理 Int？（用let转变）
    // 这样 i 就是 Int （用case转变）
    for case let i? in maybeInts {
        // i 将是 Int 值，而不是 Int?
        print(i, terminator: " ")   // 1 2
    }
    // 是以下方法的简写
    for case let .some(i) in maybeInts {}
    
    // 或者只对 nil 值进行循环
    for case nil in maybeInts {
        // 将对每个 nil 执行一次
        print("No value")
    }
    
    /// case 模式匹配
    let j = 5
    // = 符号是通过调用 ~= 操作函数来判断（此处调用 0..<10 序列的 ~=操作符 与 j 比较）
    if case 0..<10 = j {
        print("\(j)在0..<10中")
    }
    
    struct aaSubstring {
        let s: String
        init(_ s: String) { self.s = s }
        static func ~=(pattern: aaSubstring, value: String) -> Bool {
            return value.range(of: pattern.s) != nil
        }
    }
    
    

    let s = "Taylor Swift"
    let a = aaSubstring("Swift")
//    if case aaSubstring("Swift") = s {
//        print("拥有 \"Swift\" 后缀")
//    }
}



