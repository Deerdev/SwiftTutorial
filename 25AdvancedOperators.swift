//
//  25AdvancedOperators.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/6.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// Swift 默认不允许溢出，报错
// 允许溢出：使用溢出运算符 （&+ &- &*），以&开头


/// 1.运算符重载 Operator Methods
struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    /// 2.双目运算符 binary operator
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        // 返回新的 Vector2D 实例
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

extension Vector2D {
    /// 3.单目运算符，分前缀(prefix)，后缀(postfix)   unary operators
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

extension Vector2D {
    /// 4.复合赋值运算符 Compound Assignment Operators
    // 左参数 设置为 inout，左参数在运算符内被修改
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}

/// *** 不能对默认的赋值运算符（=）进行重载。只有组合赋值运算符可以被重载。同样地，也无法对三目条件运算符 （a ? b : c） 进行重载 ***


/// 5.等价运算符 Equivalence Operators
extension Vector2D {
    // 相等
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
    
    // 不等
    static func != (left: Vector2D, right: Vector2D) -> Bool {
        return !(left == right)
    }
}


/// 6.自定义运算符 Custom Operators
// 新的运算符要使用 operator 关键字在全局作用域内进行定义，同时还要指定 prefix、infix 或者 postfix 修饰符：

// 首先在全局定义操作符

prefix operator +++

extension Vector2D {
    // 前缀 双自增
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}

/// 7.自定义中缀运算符的优先级  “Precedence for Custom Infix Operators”

// 赋予AdditionPrecedence优先级
infix operator +-: AdditionPrecedence

extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

// *** 当定义前缀与后缀运算符的时候，我们并没有指定优先级。然而，如果对同一个值同时使用前缀与后缀运算符，则后缀运算符会先参与运算 ***




// 优先级和结合性 Precedence and Associativity




