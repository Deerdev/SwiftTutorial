//
//  24OpaqueTypes.swift
//  SwiftTutorial
//
//  Created by deerdev on 2023/2/7.
//  Copyright © 2023 deerdev. All rights reserved.
//

import Foundation

// Swift 提供了两种隐藏值类型细节的方法：不透明类型（Opaque Type）和封装协议类型（Boxed Protocol Type）。在隔离模块和调用模块的代码上，隐藏类型信息是有用的，因为这样返回值的底层类型可以保持私有。

/// 不透明类型
// 返回 `some protocol`

protocol ShapeX {
    func draw() -> String
}
struct Square: ShapeX {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = [String](repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}
struct Triangle: ShapeX {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
struct JoinedShape<T: ShapeX, U: ShapeX>: ShapeX {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}
struct FlippedShape<T: ShapeX>: ShapeX {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

func makeTrapezoid() -> some ShapeX {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

func testOpaqueTypes() {
    let trapezoid = makeTrapezoid()
    print(trapezoid.draw())
}

// 泛型表示
func flip<T: ShapeX>(_ shape: T) -> some ShapeX {
    return FlippedShape(shape: shape)
}
func join<T: ShapeX, U: ShapeX>(_ top: T, _ bottom: U) -> some ShapeX {
    JoinedShape(top: top, bottom: bottom)
}

/// 如果函数中有多个地方返回了不透明类型，那么所有可能的返回值都必须是同一类型（虽然不透明，但是还得是同一个类型，不同于 protocol）
// 并不会影响在返回的不透明类型中使用泛型
// 无论 T 是什么，返回值始终还是同样的底层类型 [T]， 所以这符合不透明返回类型始终唯一的要求。
func `repeat`<T: ShapeX>(shape: T, count: Int) -> some Collection {
    return [T](repeating: shape, count: count)
}

/// 封装协议类型
// any ShapeX 表示任何遵循 ShapeX 协议的类型, 且类型可以不同
// some ShapeX 表示任何遵循 ShapeX 协议的类型, 且类型必须相同
struct VerticalShapes: ShapeX {
    var shapes: [any ShapeX]
    func draw() -> String {
        return shapes.map { $0.draw() }.joined(separator: "\n\n")
    }
}

let largeTriangle = Triangle(size: 5)
let largeSquare = Square(size: 5)
let vertical = VerticalShapes(shapes: [largeTriangle, largeSquare])
print(vertical.draw())

/// 与协议的区别
/**
 两者有一个主要区别，就在于是否需要保证类型一致性。
     - 一个不透明类型只能对应一个具体的类型，即便函数调用者并不能知道是哪一种类型；
     - 协议类型可以同时对应多个类型，只要它们都遵循同一协议。
 总的来说，协议类型更具灵活性，底层类型可以存储更多样的值，而不透明类型对这些底层类型有更强的限定。
 */

/// 将协议当成类型使用时会发生类型擦除，所以并不能给协议加上对 Self 的实现
func protoFlip<T: ShapeX>(_ shape: T) -> ShapeX {
    if shape is Square {
        return shape
    }

    return FlippedShape(shape: shape)
}

/// 最直接的问题在于，Shape 协议中并没有包含对 == 运算符的声明。如果你尝试加上这个声明，那么你会遇到新的问题，就是 == 运算符需要知道左右两侧参数的类型。
/// 这类运算符通常会使用 Self 类型作为参数，用来匹配符合协议的具体类型，但是由于将协议当成类型使用时会发生类型擦除，所以并不能给协议加上对 Self 的实现要求。
func testProtoResp() {
    /*
    let protoFlippedTriangle = protoFlip(smallTriangle)
    let sameThing = protoFlip(smallTriangle)
    protoFlippedTriangle == sameThing  // 错误
     */
}

// 不能将 ContainerY 作为方法的返回类型，因为此协议有一个关联类型
protocol ContainerY {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: ContainerY {}

/*
 // 错误：有关联类型的协议不能作为返回类型。
 func makeProtocolContainer<T>(item: T) -> ContainerY {
     return [item]
 }

 // 错误：没有足够多的信息来推断 C 的类型。
 func makeProtocolContainer<T, C: ContainerY>(item: T) -> C {
     return [item]
 }
 */

/// 相比之下，不透明类型则保留了底层类型的唯一性。
/// Swift 能够推断出关联类型，这个特点使得作为函数返回值，不透明类型比协议类型有更大的使用场景
///
/// 而使用不透明类型 some ContainerY 作为返回类型，就能够明确地表达所需要的 API 契约 —— 函数会返回一个集合类型，但并不指明它的具体类型：
func testOpaqueResp() {
    func makeOpaqueContainer<T>(item: T) -> some ContainerY {
        return [item]
    }
    let opaqueContainer = makeOpaqueContainer(item: 12)
    let twelve = opaqueContainer[0]
    print(type(of: twelve))
    // 输出 "Int"

    // twelve 的类型可以被推断出为 Int， 这说明了类型推断适用于不透明类型
    /// 类型推断 依然有效
}
