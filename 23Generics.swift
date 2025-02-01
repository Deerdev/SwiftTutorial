//
//  23Generics.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/5.
//  Copyright © 2017年 deerdev. All rights reserved.
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
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
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
    typealias ItemType = Int  // 因为Swift可以通过类型推断，所以 该行可以省略

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

/// 给关联类型添加约束
// 要遵守 Container 协议，Item 类型也必须遵守 Equatable 协议

protocol ContainerX {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

/// 在关联类型约束里使用协议
// 在这个协议里，Suffix 是一个关联类型，就像上边例子中 Container 的 Item 类型一样。
// Suffix 拥有两个约束：它必须遵循 SuffixableContainer 协议（就是当前定义的协议），以及它的 Item 类型必须是和容器里的 Item 类型相同。

protocol SuffixableContainer: ContainerX {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

/// 6.扩展现有类型来指定关联类型 “Extending an Existing Type to Specify an Associated Type”

// Swift中的Array已经实现了Container协议的所有方法，直接扩展声明Container协议即可
// Array即可当 Container 用
extension Array: Container {}

/// 7.泛型Where语句 Generic Where Clauses
// 在参数列表中通过 where 子句为[关联类型]定义约束
// where 子句后跟一个或者多个针对 关联类型 的约束，以及一个或多个类型参数和关联类型间的相等关系

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2)
    -> Bool
where C1.Item == C2.Item, C1.Item: Equatable {

    /**
        C1 必须符合 Container 协议（写作 C1: Container）。
        C2 必须符合 Container 协议（写作 C2: Container）。
        C1 的 Item 必须和 C2 的 Item C1.Item == C2.Item
        C1 的 Item 必须符合 Equatable 协议（写作 C1.Item: Equatable）。
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
//    associatedtype Item
//    mutating func append(_ item: Item)
//    var count: Int { get }
//    subscript(i: Int) -> Item { get }
//}

extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}

/// 包含上下文关系的 where 分句
// 不使用该方法，需要写成两个扩展
protocol Container2 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// 例子中，当 Item 是整型时为 Container 添加 average() 方法，当 Item 遵循 Equatable 时添加 endsWith(_:) 方法。
// 两个方法都通过 where 分句对 Container 中定义的泛型 Item 进行了约束。
extension Container2 {
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count - 1] == item
    }
}
//let numbers = [1260, 1200, 98, 37]
//print(numbers.average())
//// 输出 "648.75"
//print(numbers.endsWith(37))
//// 输出 "true"

/// 具有泛型 Where 子句的关联类型
// 在关联类型后面加上具有泛型 where 的子句。
// 例如，建立一个包含迭代器（Iterator）的容器，就像是标准库中使用的 Sequence 协议那样
protocol Container3 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

    // 迭代器（Iterator）的泛型 where 子句要求：无论迭代器是什么类型，迭代器中的元素类型，必须和容器项目的类型保持一致。
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    // makeIterator() 则提供了容器的迭代器的访问接口。
    func makeIterator() -> Iterator
}

// 一个协议继承了另一个协议，你通过在协议声明的时候，包含泛型 where 子句，来添加了一个约束到被继承协议的关联类型。
// 例如，下面的代码声明了一个 ComparableContainer 协议，它要求所有的 Item 必须是 Comparable 的。
protocol ComparableContainer: Container3 where Item: Comparable {}

/// 泛型下标
// 下标可以是泛型，它们能够包含泛型 where 子句。
// 你可以在 subscript 后用尖括号来写占位符类型，你还可以在下标代码块花括号前写 where 子句
extension Container3 {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
/*
 这个 Container 协议的扩展添加了一个下标方法，接收一个索引的集合，返回每一个索引所在的值的数组。这个泛型下标的约束如下：
 - 在尖括号中的泛型参数 Indices，必须是符合标准库中的 Sequence 协议的类型。
 - 下标使用的单一的参数，indices，必须是 Indices 的实例。
 - 泛型 where 子句要求 Sequence（Indices）的迭代器，其所有的元素都是 Int 类型。这样就能确保在序列（Sequence）中的索引和容器（Container）里面的索引类型是一致的。

 综合一下，这些约束意味着，传入到 indices 下标，是一个整型的序列。
 */
