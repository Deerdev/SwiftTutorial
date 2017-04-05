//
//  23Generics.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/5.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation


/// 1.泛型函数 Generic Functions

// 交换两个变量的值，泛型类型 <T>
// 交换类型：inout
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func genericsSwapTest() {
    var someInt = 3
    var anotherInt = 107
    // 交换Int
    swapTwoValues(&someInt, &anotherInt)
    // someInt is now 107, and anotherInt is now 3
    
    var someString = "hello"
    var anotherString = "world"
    // 交换String
    swapTwoValues(&someString, &anotherString)
    // someString is now "world", and anotherString is now "hello"
}


/// 2.泛型类型 Generic Types
// 栈的泛型版本 <Element>
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
// 存储String类型
var stackOfStrings = Stack<String>()


/// 3.扩展 泛型类型 Extending a Generic Type
// 扩展一个 泛型类型 的时候，你并不需要在扩展的定义中 提供类型参数列表，参数列表在扩展中 可以直接使用
// 扩展Stack，添加计算属性topItem
extension Stack {
    // 直接使用 Element
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

/// 4.类型约束 Type Constraints
// 类型约束 可以指定一个 类型参数 必须继承自指定类，或者符合一个特定的 协议 或协议组合
// 在一个 类型参数 名后面放置一个 类名 或者 协议名

// T 必须是 SomeClass 子类的类型约束；U 必须符合 SomeProtocol 协议的类型约束
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // function body goes here
}

/// 5.关联类型 Associated Types
// 关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在 协议 被采纳时才会被指定。通过【associatedtype】关键字来指定关联类型。

// Container协议 定义了一个关联类型 ItemType
protocol Container {
    // 关联类型
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container {
    // original IntStack implementation
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container协议的实现
    // ** 指定ItermType的类型 **
    typealias ItemType = Int // 因为Swift可以通过类型推断，所以 该行可以省略
    
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// 遵循Container协议 的 Stack泛型<Element>
struct Stack1<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    // 省略了 关联类型 的指定
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

/// 6.扩展现有类型来指定关联类型 “Extending an Existing Type to Specify an Associated Type”

// Swift中的Array已经实现了Container协议的所有方法，直接扩展声明Container协议即可
// Array即可当 Container 用
extension Array: Container {}

/// 7.泛型Where语句 Generic Where Clauses
// 在参数列表中通过 where 子句为[关联类型]定义约束
// where 子句后跟一个或者多个针对 关联类型 的约束，以及一个或多个类型参数和关联类型间的相等关系

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        
        /**
        C1 必须符合 Container 协议（写作 C1: Container）。
        C2 必须符合 Container 协议（写作 C2: Container）。
        C1 的 ItemType 必须和 C2 的 ItemType类型相同（写作 C1.ItemType == C2.ItemType）。
        C1 的 ItemType 必须符合 Equatable 协议（写作 C1.ItemType: Equatable）。
        **/
        
        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // Check each pair of items to see if they are equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // All items match, so return true.
        return true
}

/// 8.带有泛型 Where 分句的扩展 “Extensions with a Generic Where Clause”
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}


//protocol Container {
//    // 关联类型
//    associatedtype ItemType
//    mutating func append(_ item: ItemType)
//    var count: Int { get }
//    subscript(i: Int) -> ItemType { get }
//}

extension Container where ItemType: Equatable {
    func startsWith(_ item: ItemType) -> Bool {
        return count >= 1 && self[0] == item
    }
}
extension Container where ItemType == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}




