//
//  11Methods.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/30.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// 实例方法

struct PointXY {
    var x = 0.0, y = 0.0
    func isToTheRightOfX(x: Double) -> Bool {
        // 使用self.x 来调用 实例属性
        return self.x > x
    }
}

/// 实例方法中修改 值类型 (可变方法)
// “结构体和枚举是值类型。默认情况下，值类型的 属性 不能在它的 实例方法 中被修改。”
// 使用可变方法
//“要使用可变方法，将关键字 mutating 放到方法的func关键字之前”

// *** 这个方法做的任何改变都会在方法 执行结束时 写回到原始结构中 ***
struct PointXY2 {
    var x = 0.0, y = 0.0
    
    // 该方法内可以修改属性
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

// *** 注意，不能在 结构体类型的常量（a constant of structure type）上调用可变方法，因为其属性不能被改变，即使 属性 是变量属性***
func PointTest() {
    let fixedPoint = PointXY2(x: 3.0, y: 3.0)
    // 这里将会报告一个错误
//    fixedPoint.moveByX(2.0, y: 3.0)
}

/// 可变方法中 给self赋值
// “可变方法能够赋给隐含属性self一个全新的实例”
struct PointXY3 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        // 对self进行重新赋值，在函数执行结束后，写入
        self = PointXY3(x: x + deltaX, y: y + deltaY)
    }
}
// *** 对于枚举类型 “可以把self设置为同一枚举类型中不同的成员” ***
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

/// 类方法
// 在方法的func关键字之前加上关键字 static ，来指定类型方法。
// * 类还可以用关键字 class 来允许子类 重写 父类的方法实现。 *


// ** 在 Swift 中，你可以为所有的 [类、结构体和枚举] 定义类型方法 **
class SomeClassHasClassMethod {
    // 允许子类重写的类方法
    class func someTypeMethod() {
        // 在这里实现类型方法
    }
}

// 在类型方法的方法体（body）中，self指向这个【类型本身】，而不是类型的某个实例。这意味着你可以用self来消除【类型属性】和类型方法参数之间的歧义
// 类方法 修改  类属性
struct LevelTracker {
    // 类属性
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    // 类方法
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }

    // 类方法
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    // 可变方法，修改currentLevel属性
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}







