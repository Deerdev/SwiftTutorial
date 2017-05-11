//
//  06Functions.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/3/14.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

func greet (person: String) -> String {
    let greeting = "Hello" + person + "!"
    return greeting
}

func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    
    for value in array {
        if value < currentMin {
            currentMin = value
        }
        if value > currentMax {
            currentMax = value
        }
    }
    
    return (currentMin, currentMax)
}

/// 返回可选类型Optional Tuple Return Types (_, _)?
// (a, b)? 和 (a?, b?)是不一样的
func minMaxOptional(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty {
        return nil
    }
    
    var currentMin = array[0]
    var currentMax = array[0]
    
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        }
        if value > currentMax {
            currentMax = value
        }
    }
    
    return (currentMin, currentMax)
}

func testminMaxOptional() -> Void {
    if let value = minMaxOptional(array: [8, -8, 9, 1]) {
        print("min is \(value.min) and max is \(value.max)")
    }
}

/// 函数参数的定义: (标签 变量名: 变量类型)
//func someFunction(argumentLabel parameterName: Int)

func greet(person: String, from hometown: String) -> String {
    return hometown
}

/// Omitting Argument Labels 使用 "_" 代替标签（第一个可以省略）
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    
}

/// Default Parameter Values 默认形参
func someFunction2(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    
}
// 调用
// someFunction2(parameterWithoutDefault:3)

/// 可变参数 Variadic Parameters
// 每个函数只能有一个可变参数
func arithmeticMean(_ numbers: Double...) -> Double {
    // 参数在内部是一个数组
    var total: Double = 0
    for number in numbers {
        total += number
    }
    
    return total / Double(numbers.count)
}

/// 输入输出参数 In-Out Parameters
/// inout不是对参数的引用，而是在函数执行结束后，再将结果写入到外部变量的内存中
/// 不允许逃逸inout参数，可能逃逸闭包执行结束后，原始变量的内存已经不存在了

// inout关键字，表示参数在函数内可被修改
// 交换a,b之间的值
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tmporaryA  = a
    a = b
    b = tmporaryA
}

// 使用引用方式传入参数 "&"
func testSwap() -> Void {
    var someInt = 3
    var anotherInt = 107
    swapTwoInts(&someInt, &anotherInt)
    print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
}

/// using Function Types 使用函数类型
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

//var mathFuntion: (Int, Int)->Int = addTwoInts
var mathFuntion = addTwoInts
var sum = mathFuntion(2, 3)

/// 函数类型作为参数 Function Types as Parameter Types
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result:\(mathFuntion(a, b))")
}

// 调用
//printMathResult(addTwoIntsc, 3, 5)


/// 函数类型作为返回类型 Function Types as Return Types
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
// 返回函数名来返回对应的函数
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}

var currentValue = 3
// 取出函数存到moveNearerToZero
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
var aaa = moveNearerToZero(3)

/// 嵌套函数 nested Functions
func chooseStepFunction2(backward: Bool) -> (Int) -> Int {
    // 嵌套1
    func stepForward2(_ input: Int) -> Int {
        return input + 1
    }
    // 嵌套2
    func stepBackward2(_ input: Int) -> Int {
        return input - 1
    }
    return backward ? stepBackward2 : stepForward2
}










