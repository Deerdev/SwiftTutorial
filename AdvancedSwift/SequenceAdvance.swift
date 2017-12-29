//
//  SequenceAdvance.swift
//  SwiftTutorial
//
//  Created by daoquan on 2017/12/21.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

// MARK: - 🔴链表(枚举) -
/// 链表(枚举)
// 一个简单的链表枚举
// “使用 indirect 关键字可以告诉编译器这个枚举值应该被看做引用”
enum MyList<Element> {
    case end
    indirect case node(Element, next: MyList<Element>)
}

extension MyList {
    /// 在链表 前方 添加一个值为 `x` 的节点，并返回这个链表
    func cons(_ x: Element) -> MyList {
        return .node(x, next: self)
    }
}

// 使用"数组字面量" 初始化 [1, 2, 3]
extension MyList: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }
    }
}

func ListAdvance() {
    // 一个拥有 3 个元素的链表 (3 2 1)
    let list = MyList<Int>.end.cons(1).cons(2).cons(3)
    print(list)
    // node(3, List<Swift.Int>.node(2, List<Swift.Int>.node(1, List<Swift.Int>.end)))
    
    let list2: MyList = [3,2,1]
    print(list2)
    // node(3, List<Swift.Int>.node(2, List<Swift.Int>.node(1, List<Swift.Int>.end)))
}

// MARK: - 🔴栈 -
/// 栈

// 一个进栈和出栈都是常数时间操作的后进先出 (LIFO) 栈
protocol MyStack {
    /// 栈中存储的元素的类型
    associatedtype Element
    /// 将 `x` 入栈到 `self` 作为栈顶元素
    /// - 复杂度：O(1).
    mutating func push(_ x: Element)
    /// 从 `self` 移除栈顶元素，并返回它
    /// 如果 `self` 是空，返回 `nil`
    /// - 复杂度：O(1)
    mutating func pop() -> Element?
}

/*  Array 可以遵守 Stack：
    extension Array: MyStack {
        mutating func push(_ x: Element) { append(x) }
        mutating func pop() -> Element? { return popLast() }
    }
 */

// 链表实现
extension MyList: MyStack {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(x, next: xs):
            self = xs
            return x
        }
    }
}

/*
 a
 +
 |
 v
 +-------+      +-------+      +-------+      +-------+
 |3  next+----> |2 |next+----> |1 |next+----> |  .end |
 +-------+      +-------+      +-------+      +-------+
 ^
 |
 b

 
 a
 |
 v
 +-------+      +-------+      +-------+      +-------+
 |3 |next+----> |2 |next+----> |1 |next+----> |  .end |
 +-------+      +---+---+      +-------+      +-------+
                 ^
                 |
                 b.pop()

 
                 a.pop()
                 |
                 v
 +-------+      +---+---+      +-------+      +-------+
 |3 |next+----> |2 |next+----> |1 |next+----> |  .end |
 +-------+      +---+---+      +-------+      +-------+
 ^               ^
 |               |
 内存回收          b.pop()
 

 */
func stackAdvance() {
    var stack: MyList<Int> = [3,2,1]
    var a = stack
    var b = stack
    _ = a.pop() // Optional(3)
    _ = a.pop() // Optional(2)
    _ = a.pop() // Optional(1)
    _ = stack.pop() // Optional(3)
    stack.push(4)
    _ = b.pop() // Optional(3)
    _ = b.pop() // Optional(2)
    _ = b.pop() // Optional(1)
    _ = stack.pop() // Optional(4)
    _ = stack.pop() // Optional(2)
    _ = stack.pop() // Optional(1)
}

/// 让链表 遵守 Sequence
extension MyList: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

func ListSequenceTest() {
    let list: MyList = ["1", "2", "3"]
    // 实现了next()，可以使用for in
    for x in list {
        print("\(x) ", terminator: "")
    } // 1 2 3
    
    // collection
    let list2: MyListCollection = ["one", "two", "three"] // List: (one, two, three)
    _ = list2.first // Optional("one")
    _ = list2.index(of: "two") // Optional(ListIndex(2))
    _ = list2.count // 3
}

// MARK: - 🔴链表到 Collection -
/// 让链表 遵守Collection
// <-------------------------- 实现 index 满足Comparable--------------------------->
/*
 为了实现下标索引的O(1)，链表需要将索引直接与节点关联，即索引必须直接引用链表的节点；
 采用索引类型封装Node的做法，并将Node私有实现，隐藏细节
 */
// List 集合类型的私有实现细节
fileprivate enum MyListNode<Element> {
    case end
    indirect case node(Element, next: MyListNode<Element>)
    func cons(_ x: Element) -> MyListNode<Element> {
        return .node(x, next: self)
    }
}

public struct MyListIndex<Element>: CustomStringConvertible {
    fileprivate let node: MyListNode<Element>
    // 使用一个递增的数字来作为每个索引的标记值 (tag) (.end 节点的标记值为 0)
    // 满足Comparable
    fileprivate let tag: Int
    public var description: String {
        return "ListIndex(\(tag))"
    }
}
/*
 虽然 ListIndex 是被标记为公开的结构体，但是它有两个私有属性 (node 和 tag) 。
 这意味着该结构体不能被从外部构建，因为它的“默认”构造函数 ListIndex(node:tag:) 对外部用户来说是不可见的。
 你可以从一个 List 中拿到 ListIndex，但是你不能自己创建一个 ListIndex。
 这是非常有用的技术，它可以帮助你隐藏实现细节，并提供安全性。
 */
// <-------------------------- 实现 index(满足Comparable)的 == 和 < --------------------------->
/*
 Comparable 有两个要求：它需要实现一个小于运算符 (<) 和 一个从 Equatable 继承的等于运算符 (==)。
 一旦有了这两个运算符实现，另外的像是 >，<= 和 >= 都可以使用默认的实现。
 */
extension MyListIndex: Comparable {
    public static func == <T>(lhs: MyListIndex<T>, rhs: MyListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    public static func < <T>(lhs: MyListIndex<T>, rhs: MyListIndex<T>) -> Bool {
        // startIndex 的 tag 值最大, endIndex 最小
        return lhs.tag > rhs.tag
    }
}

// <-------------------------- 实现Collection协议 --------------------------->
public struct MyListCollection<Element>: Collection {
    // Index 的类型可以被推断出来，不过写出来可以让代码更清晰一些
    public typealias Index = MyListIndex<Element>
    public let startIndex: Index
    public let endIndex: Index
    
    // 当前index所对应的 node
    public subscript(position: Index) -> Element {
        switch position.node {
        case .end: fatalError("Subscript out of range")
        case let .node(x, _): return x
        }
    }
    
    // 当前index的下一个index
    public func index(after idx: Index) -> Index {
        switch idx.node {
        case .end: fatalError("Subscript out of range")
        case let .node(_, next): return Index(node: next, tag: idx.tag - 1)
        }
    }
    
    // 因为 List 和 ListIndex 是两个不同类型，我们可以为 List 实现一个不同的 == 运算符，用来比较集合中的元素
    static public func == <T: Equatable>(lhs: MyListCollection<T>, rhs: MyListCollection<T>) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}


/*
 注意 List 除了 startIndex 和 endIndex 以外并不需要存储其他东西。
 因为索引封装了列表节点，而节点又相互联系，所以你可以通过 startIndex 来访问到整个列表。
 endIndex 对于所有的实例 (至少在我们之后谈及切片前) 来说，都是相同的 ListIndex(node: .end, tag: 0)
 */
// 数组字面量 初始化
extension MyListCollection: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        // [1, 2, 3]  -> ( [.end] <- [3] <- [2] <- [1] )
        startIndex = MyListIndex(node: elements.reversed().reduce(.end) {
            partialList, element in
            partialList.cons(element)   // 返回head指针
        }, tag: elements.count)
        endIndex = MyListIndex(node: .end, tag: 0)
    }
}

extension MyListCollection: CustomStringConvertible {
    public var description: String {
        let elements = self.map { String(describing: $0) }
            .joined(separator: ", ")
        return "List: (\(elements))"
    }
}

// 链表长度O(n)，通过tag优化为 O(1)
extension MyListCollection {
    public var count: Int {
        return startIndex.tag - endIndex.tag
    }
}

// MARK: - 🔴切片
/// 切片
func sliceAdvance() {
    let list: MyListCollection = [1,2,3,4,5]
    let onePastStart = list.index(after: list.startIndex)
    let firstDropped = list[onePastStart..<list.endIndex]   // Slice<MyListCollection<Int>>
    let dropArray = Array(firstDropped)
    print(dropArray)    // [2, 3, 4, 5]
    let firstDropped2 = list.suffix(from: onePastStart)
    print(firstDropped2)
    // Slice<MyListCollection<Int>>(_startIndex: ListIndex(4), _endIndex: ListIndex(0), _base: List: (1, 2, 3, 4, 5))
    // tag是从 5->0的，所以第二个是从ListIndex(4)开始
    
    
    /*
     除了保存对原集合类型的引用之外，Slice 还存储了切片边界的 开始索引 和 结束索引。
     所以在 List 的场合，因为列表【本身是由两个索引】组成的，所以切片占用的大小也将会是原来列表的两倍：
     */
    // 一个拥有两个节点 (start 和 end) 的列表的大小：
    print(MemoryLayout.size(ofValue: list)) // 32
    
    // 切片的大小是列表的大小再加上子范围的大小
    // (两个索引之间的范围。在 List 的情况下这个范围也是节点)
    print(MemoryLayout.size(ofValue: list.dropFirst())) //64（实现自定义 切片后 64 -> 32）
    
    // 实现自定义 切片后 64 -> 32
    let list1: MyListCollection = [1, 2, 3, 4, 5]
    print(MemoryLayout.size(ofValue: list1.dropFirst()))    // 32
}

// Slice的实现
struct MySlice<Base: Collection>: Collection {
    typealias Index = Base.Index
    typealias IndexDistance = Base.IndexDistance
    let collection: Base
    var startIndex: Index
    var endIndex: Index
    
    init(base: Base, bounds: Range<Index>) {
        collection = base
        startIndex = bounds.lowerBound
        endIndex = bounds.upperBound
    }
    
    func index(after i: Index) -> Index {
        return collection.index(after: i)
    }
    
    subscript(position: Index) -> Base.Iterator.Element {
        return collection[position]
    }
    
    typealias SubSequence = MySlice<Base>
    
    subscript(bounds: Range<Base.Index>) -> MySlice<Base> {
        return MySlice(base: collection, bounds: bounds)
    }
}

// 实现自定义 切片
extension MyListCollection {
    public subscript(bounds: Range<Index>) -> MyListCollection<Element> {
        // 返回自身，只是持有不同的起始索引 和 结束索引 来表示一个子序列，序列内存和序列相同
        return MyListCollection(startIndex: bounds.lowerBound, endIndex: bounds.upperBound)
    }
}

/*
 另一件需要考虑的事情是，对于包括 Swift 数组和字符串在内的很多可以被切片的容器，它们的切片将和原来的集合共享存储缓冲区。
 这会带来一个不好的副作用：切片将在它的整个生命周期中持有集合的缓冲区，而不论集合本身是不是已经超过了作用范围。
 如果你将一个 1 GB 的文件读入到数组或者字符串中，然后获取了它的很小的一个切片，整个这 1 GB 的缓冲区会一直存在于内存中，
 直到集合和切片都被销毁时才能被释放。这也是 Apple 在文档中特别警告“只应当将切片用作临时计算的目的”的原因。
                         |
                         |
                         v
 对于MyListCollection，该问题不严重，因为节点通过ARC来管理：
 当切片是仅存的复制时，所有在切片前方的节点都会变成无人引用的状态，这部分内存将得到回收
 
                            a.suffix(2)
                    +------------+----------+
                    | startIndex | endIndex |
                 +--+------------+----------+-----+
                 |                                |
                 |                                |
                 |                                |
         +-----+-v-+------+         +-----+---+---v--+
         | tag | 2 | node |         | tag | 0 | node |
         +-----+---+-----++         +-----+---+------+----+
                         |                                |
                         |                                |
                         |                                |
+---+------+      +---+--v---+      +---+------+      +---v--+
| 4 | next +------> 5 | next +------> 6 | next +------> .end |
+---+------+      +---+------+      +---+------+      +------+
 节点被回收
 
 
                            a.prefix(2)
                     +------------+----------+
                     | startIndex | endIndex |
                  +--+------------+----------+-----+
                  |                                |
                  |                                |
          +-----+-v-+------+         +-----+---+---v--+
          | tag | 3 | node |         | tag | 2 | node |
          +-----+---+---+--+         +-----+---+---+--+
                        |                          |
   +--------------------+                          |
   |                 +-----------------------------+
   |                 |
 +-v-+------+      +-v-+------+      +---+------+      +------+
 | 4 | next +------> 5 | next +------> 6 | next +------> .end |
 +---+------+      +---+------+      +---+------+      +------+
                                    节点不会被回收（5索引6，6索引end）
 */









