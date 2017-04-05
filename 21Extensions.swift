//
//  21Extensions.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/5.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 1.扩展: 就是为一个已有的类、结构体、枚举类型 或者 协议类型 添加新功能(** 但不能重写已有功能 **)

/// 2.扩展语法
/**
 extension SomeType {
 // new functionality to add to SomeType goes here
 }
 
 // 扩展已有类型，采纳一个或多次 协议
 extension SomeType: SomeProtocol, AnotherProtocol {
 // implementation of protocol requirements goes here
 }
**/

// 如果你通过扩展为一个已有类型添加新功能，那么新功能对该类型的 所有已有实例都是可用的，即使它们是在这个扩展定义之前创建的。

/// 3.扩展 计算型属性
// 为Double添加计算型属性
extension Double {
    var km: Double { return self * 1_000.0 }
    var  m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
// Prints "0.0254 meters"

let threeFeet = 3.ft
// Prints "0.914399970739201 meters"

// *** 扩展可以添加新的 计算属性，但是 不能添加存储属性，也 不能为已有的属性添加属性观察者。 ***

/// 4.构造器
// *** 扩展能为类添加新的 便利构造器，但是它们 不能为类添加新的指定构造器或析构器 ***
// 如果你使用扩展为一个值类型添加构造器，同时该值类型的 原始实现中 未定义任何定制的构造器且所有存储属性提供了默认值，
// 那么我们就可以在扩展中的构造器里调用 默认构造器 和 逐一成员构造器(链接14Initialization-8)
struct Size1 {
    var width = 0.0, height = 0.0
}
struct Point1 {
    var x = 0.0, y = 0.0
}
struct Rect1 {
    var origin = Point1()
    var size = Size1()
}

extension Rect1 {
    init(center: Point1, size: Size1) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // 调用逐一成员构造器
        self.init(origin: Point1(x: originX, y: originY), size: size)
    }
}

/// 5.方法
// “扩展可以为已有类型添加新的实例方法和类型方法”
extension Int {
    // 闭包参数
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

extension Int {
    // 可变实例方法，修改变量本身的值
    mutating func square() {
        self = self * self
    }
}

/// 6.下标
extension Int {
    // 下标函数 subscript
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}


/// 7.嵌套类型
// “为已有的类、结构体和枚举 添加新的嵌套类型”
extension Int {
    // 嵌套枚举
    enum Kind {
        case Negative, Zero, Positive
    }
    
    var kind: Kind {
        // self作为实例本身（Int）
        switch self {
        case 0:
            // 因为self是Int类型，kind是Kind类型，所以直接使用 .Zero语法
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}







