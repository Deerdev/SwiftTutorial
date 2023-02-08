//
//  09ClassAndStruct.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/29.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

// 结构体
struct Resolution {
    var width = 0
    var height = 0
}

// 类
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someResolution = Resolution()
let someVideoMode = VideoMode()

/// 所有结构体都有一个自动生成的成员[逐一构造器]
let vga = Resolution(width:640, height: 480)


/// 恒等运算 Identity Operators
// === "等价于"表示两个类类型（class type）的常量或者变量引用[同一个类实例]。
// == "等于"表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准，因此相对于“相等”来说，这是一种更加合适的叫法。
func identityOperators() {
    let tenEighty = VideoMode()
    let alsoTenEighty = tenEighty
    if tenEighty === alsoTenEighty {
        print("tenEighty and alsoTenEighty refer to the same Resolution instance.")
    }
}
    
/// 类 和 结构体 的选择

/** 按照通用的准则，当符合一条或多条以下条件时，请考虑构建【结构体】：

--- 该数据结构的主要目的是用来封装少量相关简单数据值。
--- 有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用。
--- 该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用。
--- 该数据结构不需要去继承另一个既有类型的属性或者行为。
**/

/// Swift 中，许多基本类型，诸如String，Array和Dictionary类型均以【结构体】的形式实现。(swift优化后，写时拷贝)
/// Objective-C 中NSString，NSArray和NSDictionary类型均以类的形式实现，而并非结构体。

