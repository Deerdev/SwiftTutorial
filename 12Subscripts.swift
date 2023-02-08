//
//  12Subscripts.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/31.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation


/// 下标使用subscript关键字，指定一个或多个输入参数和返回类型；
// 与实例方法不同的是，下标可以设定为读写或只读。这种行为由 getter 和 setter 实现，有点类似计算型属性：

struct TimesRWTable {
    var multiplier: Int
    // 读写下标定义
    subscript(index: Int) -> Int {
        get {
            // 返回一个适当的 Int 类型的值
            return multiplier;
        }
        
        set(newValue) {
            // 执行适当的赋值操作
            multiplier = newValue;
        }
    }
}

/// 只读下标
struct TimesRTable {
    let multiplier: Int
    // 直接return
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

func dictSubscriptTest() {
    var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
    //该例子通过下标将String类型的键bird和Int类型的值2添加到字典中。
    numberOfLegs["bird"] = 2
    // “字典也提供一种通过 键 删除对应 值 的方式，只需将键对应的值赋值为 nil 即可。
}

/// 多个下标
// 但是，与函数不同的是，下标不能使用 in-out 参数。
//subscript(row: Int, column: Int) -> Double {
//    get {
//
//    }
//    set {
//
//    }
//}

// 使用：matrix[0, 1] = 1.5


/// 类型下标: 在这个类型自身上调用的下标（应用在类型 Type 上，不是实例上）
// `static subscript`
// class 可以是 `class subscript`
enum Planet2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet2 {
        return Planet2(rawValue: n)!
    }
}
let mars = Planet2[4]
//print(mars)






