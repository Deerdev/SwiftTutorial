//
//  18ErrorHandling.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/4.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 枚举，继承Error协议
enum VendingMachineError: Error {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

/// throw 抛出错误
//throw VendingMachineError.InsufficientFunds(coinsNeeded: 5)

/// 错误的处理方式
/**
 *1.“把函数抛出的错误传递给调用此函数的代码”
 *2.“用do-catch语句处理错误”
 *3.“将错误作为可选类型处理”
 *4.“断言此错误根本不会发生”
**/

// Swift 中的错误处理并不涉及 解除调用栈，这是一个计算代价高昂的过程。就此而言，throw语句的性能特性是可以和return语句相媲美的。




/// 用 throwing 函数传递错误  Propagating Errors Using Throwing Functions
// 只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理
struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
    // throws 关键字，将错误传递出去
    func vend(itemNamed name: String) throws -> Void{
        guard var item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(snack: name)
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    
    // 使用try来 处理vend抛出的错误
    try vendingMachine.vend(itemNamed: snackName)
}


/// 用 Do-Catch 处理错误 Handling Errors Using Do-Catch
// “do-catch语句运行一段闭包代码来处理错误”
/*
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
}
*/

// 在catch后面写一个匹配模式来表明这个子句能处理什么样的错误。
// 如果一条catch子句没有指定匹配模式，那么这条子句可以匹配任何错误，并且把错误绑定到一个名字为error的局部常量

func doCatchFunc() {
    
    var vendingMachine = VendingMachine()
    vendingMachine.coinsDeposited = 8
    do {
        try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
        // Enjoy delicious snack
    } catch VendingMachineError.InvalidSelection {
        print("Invalid Selection.")
    } catch VendingMachineError.OutOfStock {
        print("Out of Stock.")
    } catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
        print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
    } catch {
        // 处理其他Error
        // 因为try可能存在unknown error，不仅仅是VendingMachineError类型的error
    }
}


/// 将错误转换成可选值 “Converting Errors to Optional Values”
// *** 用try?通过将错误转换成一个可选值来处理错误，出错就返回 nil ***

func someThrowingFunction() throws -> Int {
    // ...
    return 0
}

func someThrowingFunctionNotThrows() {
    let x = try? someThrowingFunction()
    
    var y: Int?
    do {
        y = try someThrowingFunction()
    } catch {
        y = nil
    }
}


/// 禁用错误传递 Disabling Error Propagation
// try! : 该错误不会在运行时抛出
// 运行时不会有错误抛出，所以适合禁用错误传递

/*
let photo = try! loadImage("./Resources/John Appleseed.jpg")
*/


/// 指定清理操作 Specifying Cleanup Actions
// *** 使用【defer】语句在即将离开当前代码块时执行一系列语句 ***
// “defer语句将代码的执行延迟到当前的作用域退出之前”
// “延迟执行的语句不能包含任何控制转移语句，例如break或是return语句，或是抛出一个错误”
// 延迟执行的操作会按照它们被指定时的顺序的【相反顺序】执行———也就是说，第一条defer语句中的代码会在第二条defer语句中的代码被执行之后才执行

/*
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        
        // 异常退出时（打开失败），延迟退出，先关闭文件
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
*/








