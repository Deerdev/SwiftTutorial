//
//  08Enumerations.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/3/26.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 枚举的定义
enum CompassPoint {
    case north
    case south
    case east
    case west
}

func enumDefine() {
    var directionToHead = CompassPoint.west
    // swift 已经可以推导directionToHead的类型，直接使用.east
    directionToHead = .east
    
    directionToHead = .south
    // switch语句相同
    switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
    }
    // 打印 "Watch out for penguins”
}

/// 关联值 Associated Values
//  一个枚举类型关联一个值（元组）
enum Barcode {
    // 定义一个名为Barcode的枚举类型
    // 它的一个成员值是具有(Int，Int，Int，Int)类型关联值的upc
    // 另一个成员值是具有String类型关联值的qrCode
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

func barcodeTest() {
    // 条形码
    var productBarcode = Barcode.upc(8, 85909, 51226, 3)
    // 赋值为 二维码
    productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
    
    // switch内部 用变量提取关联值 直接使用
    switch productBarcode {
        // 成员变量被提取为常量（也可以提取为变量 var）
        case .upc(let numberSystem, let manufacturer, let product, let check):
            print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
        // 如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员 名称前 标注一个let或者var：
        case let .qrCode(productCode):
            print("QR code: \(productCode).")
    }
}

/// 原始值 Raw Values
// 枚举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同。
// 预填充 不可变 类型一致
// 原始值可以是字符串，字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。

enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
// 原始值 隐式赋值
// 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。
// Int默认从0开始
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
// CompassPoint.south拥有隐式原始值south，依次类推。
enum CompassPointStr: String {
    case north, south, east, west
}

// 使用枚举成员的rawValue属性可以访问该枚举成员的原始值：
let earthsOrder = Planet.earth.rawValue // earthsOrder 值为 3
let sunsetDirection = CompassPointStr.west.rawValue // sunsetDirection 值为 "west

//使用原始值初始化 枚举实例 （返回 【可选类型】）
let possiblePlanet = Planet(rawValue: 7) // possiblePlanet 类型为 Planet? 值为 Planet.uranus

/// 递归枚举 Recursive Enumerations
// 一个或多个枚举成员使用该枚举类型的实例作为关联值
// 在枚举成员前加上 indirect
enum ArithmeticExpression1 {
    case number(Int)
    indirect case addition(ArithmeticExpression1, ArithmeticExpression1)
    indirect case multiplication(ArithmeticExpression1, ArithmeticExpression1)
}

// 在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
// 创建 表达式（5+4）*2
func testMultiply() {
    let five = ArithmeticExpression.number(5)
    let four = ArithmeticExpression.number(4)
    let sum = ArithmeticExpression.addition(five, four)
    let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
    print("(5+4)*2 : \(product)")
}
