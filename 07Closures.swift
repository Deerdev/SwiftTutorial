//
//  07Closures.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/17.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// 闭包定义

// parameters参数可以是inout参数，不能有默认值

//{ (parameters) -> return type  in
//    statements
//}

func sortArray() {
    let names = ["aa", "bb", "cc", "dd"]
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    // 排序（函数参数）
    var result1 = names.sorted(by: backward)
    
    // 排序（闭包参数）
    var result2 = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2})
    
    // 简化1：sortec(by:)已经定义了闭包的参数类型和返回 (String, String) -> Bool
    var result3 = names.sorted(by: { s1, s2 in return s1 > s2})
    
    // 简化2:sortec(by:)已经定义了返回，当闭包只有一行时，省略return
    var result4 = names.sorted(by: { s1, s2 in s1 > s2})
    
    /// 参数名称省略(Shorthand Argument Names)
    // swift提供了默认参数缩写$0,$1,$2...
    var result5 = names.sorted(by: { $0 > $1 })
    
    /// 运算符方法(Operator Methods)
    var result6 = names.sorted(by: >)
    
    
}

/// 尾随闭包(Trailing Closures)
// 闭包作为函数参数中最后一个参数，闭包可以写在参数列表外面(调用时省略参数标签)
func trailingTest() {
    func someFunctionThatTakesAClosure(closure: () -> Void) {
        // function body goes here
    }
    someFunctionThatTakesAClosure(closure: {
        // 闭包体在参数列表内
        // closure's body goes here
    })
    
    someFunctionThatTakesAClosure() {
        // 闭包在参数列表外(尾随)
        // trailing closure's body goes here
    }
    
    // 当参数是唯一参数时，参数()可以省略
    someFunctionThatTakesAClosure {
        // 闭包在参数列表外(尾随)
        // trailing closure's body goes here
    }
    
    let names = ["aa", "bb", "cc", "dd"]
    var result1 = names.sorted{ $0 > $1 }
    
    // 对map函数的尾随闭包，将int转为sting
    let numbers = [16, 58, 510]
    let digitNames = [
        0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
        5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
    ]
    let strings = numbers.map {
        (number) -> String in
        var number = number
        var output = ""
        repeat {
            // ditiNames[]取值是可选类型 ！
            output = digitNames[number % 10]! + output
            number /= 10
        } while number > 0
        return output
    }
    
    /// 如果一个函数接受多个闭包，您需要省略第一个尾随闭包的参数标签，并为其余尾随闭包添加标签。例如，以下函数将为图片库加载一张
    /*
    func loadPicture(from server: Server, completion:(Picture) -> Void, onFailure: () -> Void) {
        if let picture = download("photo.jpg", from: server){
            completion(picture)
        }else{
            onFailure()
        }
    }
    
    // completion 标签隐藏
    loadPicture(from: someServer){ picture in
        someView.currentPicture = picture
    } onFailure: {
        print("Couldn't download the next picture.")
    }
    */
}

/// 值捕获 Capturing values
// 闭包可以在其被定义的上下文中捕获常量或变量，即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值

// incrementer()函数捕获外部 runningTotal和amount参数
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

// 注意 为了优化，如果一个值不会被闭包改变，或者在闭包创建后不会改变，Swift 可能会改为捕获并保存一份对值的拷贝。
// Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。
func capturingValueTest() {
    let incrementByTen = makeIncrementer(forIncrement: 10)
    incrementByTen() // return 10
    incrementByTen() // return 20
    
    /// 函数和闭包 都是引用类型(会增加引用计数)
    let alsoIncrementByTen = incrementByTen
    alsoIncrementByTen() // 返回的值为30
    // 如果你将闭包赋值给一个类实例的属性，并且该闭包通过访问该实例或其成员而捕获了该实例，你将在闭包和该实例间创建一个循环强引用。
}

/// 逃逸闭包 Escaping Closures
// 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸
// 在参数名之前标注 @escaping，用来指明这个闭包是允许“逃逸”出这个函数的
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

// ---- ---------------
class SomeClass {
    var x = 10
    func doSomething() {
        // 将一个闭包标记为 @escaping 意味着你必须在闭包中显式地引用 self
        // 将闭包添加到completionHandlers，但不执行
        someFunctionWithEscapingClosure { self.x = 100 }
        // 相对的，传递到 someFunctionWithNonescapingClosure(_:) 中的闭包是一个非逃逸闭包，这意味着它可以隐式引用 self。
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

func someClassTest() {
    
    let instance = SomeClass()
    instance.doSomething()
    print(instance.x) // 打印出 "200"
    
    // 执行completionHandlers中的第一个闭包{ self.x = 100 }
    completionHandlers.first?()
    print(instance.x) // 打印出 "100”
}
// ---- ---------------

/// 自动闭包 Autoclosures
func autoClosureTest() {
    // 自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。
    // 这种闭包 “不接受任何参数”，当它被调用的时候，会返回被包装在其中的表达式的值。
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    print(customersInLine.count)
    // 打印出“5”

    let customerProvider = { customersInLine.remove(at: 0) }
    print(customersInLine.count)
    // 打印出“5”

    print("Now serving \(customerProvider())!")
    // 打印出“Now serving Chris!”
    print(customersInLine.count)
    // 打印出“4”
    
    
    // 这种便利语法让你能够 省略 闭包的“花括号”，用一个普通的表达式来代替显式的闭包。
    // 参数使用 @autocloseure 表示
    customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    func serve(customer customerProvider: @autoclosure () -> String) {
        print("Now serving \(customerProvider())!")
    }
    // 注意 过度使用 autoclosures 会让你的代码变得难以理解。上下文和函数名应该能够清晰地表明求值是被延迟执行的。
    // 可能在函数的内部逻辑中，也不会执行 自动闭包
    serve(customer: customersInLine.remove(at: 0))
}

// 自动闭包 也可以 逃逸 ，参数加 @autoclosure @escaping 标识
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}



















