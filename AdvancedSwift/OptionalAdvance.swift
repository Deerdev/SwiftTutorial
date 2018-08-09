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
        print(maybeInt, terminator: " ")    // [Optional(1), Optional(2), nil]
    }
    
    // for...in是while循环加上一个迭代器
    var iterator = maybeInts.makeIterator()
    // *** next()返回的是Optional<Optional<Int>>
    // *** 所以最后一个 some(nil) 也会进入while循环
    while let maybeInt = iterator.next() {
        print(maybeInt)     // Optional(1) Optional(2) nil
    }

    // while let 后面还可以 添加Bool判断
    // while let line = readLine(), !line.isEmpty { print(line) }

    // 【使用if case，取出非nil的值】
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
    // case= 符号是通过调用 ~= 操作函数来判断（此处调用 0..<10 序列的 ~= 操作符 与 j 比较，~=返回false 就进入for循环）
    if case 0..<10 = j {
        print("\(j)在0..<10中")
    }

    // ------------------------------
    struct aaSubstring {
        let s: String
        init(_ s: String) { self.s = s }

    }

    // 假设定义一个全局的 ~= 操作
//    func ~=(pattern: aaSubstring, value: String) -> Bool {
//        return value.range(of: pattern.s) != nil
//    }

    let s = "Taylor Swift"
    let a = aaSubstring("Swift")
//    if case a = s {
//        print("拥有 \"Swift\" 后缀")
//    }
    // ------------------------------


    /// 可选链
    // b = 10 是直接赋值；b? = 10 是当b不为nil时，才赋值
    var b: Int? = 5
    b? = 10  // Optional(10)

    /// 可选型map
    let opStringNumbers = ["1", "2", "3", "foo"]
    let x = opStringNumbers.first.map { Int($0) } // Optional(Optional(1))
    // 返回 Int??
    /*
    extension Optional {
        func map<U>(transform: (Wrapped) -> U) -> U? {
            if let value = self {
                return transform(value)
            }
            return nil
        }
    }
     */
    /// 可选型flatmap
    // flatMap 可以把结果展平为单个可选值
    let y = opStringNumbers.first.flatMap { Int($0) } // Optional(1)
    /*
    extension Optional {
        func flatMap<U>(transform: (Wrapped) -> U?) -> U? {
            if let value = self, let transformed = transform(value) {
                return transformed
            }
            return nil
        }
    }
    */
    // 数组操作
    let xx = opStringNumbers.map { Int($0) }    // [Optional(1), Optional(2), Optional(3), nil]
    let yy = opStringNumbers.flatMap { Int($0) }    // [1, 2, 3]

    /// 给字典赋值nil
    // 正常给字典赋值nil 是移除该键值对
    var dictWithNils: [String: Int?] = [ "one": 1, "two": 2, "none": nil ]
    // 移除two
//    dictWithNils["two"] = nil
    dictWithNils["two"] = Optional(nil)
    dictWithNils["two"] = .some(nil)
    dictWithNils["two"]? = nil
    // ["none": nil, "one": Optional(1), "two": nil]
}

func saftyAboutForIn() {
    // for...in 其实就是 while let
    // where let翻译一下就是：
    var functions1: [() -> Int] = []
    var iterator1 = (1...3).makeIterator()
    var current1: Int? = iterator1.next()
    while current1 != nil {
        let i = current1!
        functions1.append { i }
        current1 = iterator1.next()
    }
    // 可以看出 i 是循环内[局部变量]，每次functions1捕获的都是不同的值;最后可以打印123

    // Ruby 或其他语言中，i是[循环外部的全局变量]，这样每次lambda其实都是捕获的同一个i；最后打印 3 3 3
    /*
     functions = []
     for i in 1..3
        functions.push(lambda { i })
     end

     for f in functions
        print "#{f.call()} "
     end
 */
}

