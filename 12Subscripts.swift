//
//  12Subscripts.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/3/31.
//  Copyright © 2017年 daoquan. All rights reserved.
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
//subscript(row: Int, column: Int) -> Double {
//    get {
//
//    }
//    set {
//
//    }
//}









