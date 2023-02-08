//
//  ex_Math.swift
//  SwiftTutorial
//
//  Created by Deer on 2019/9/1.
//  Copyright © 2019 deerdev. All rights reserved.
//

import Foundation

/// 新的random函数(Swift4.2)
// 之前的C方法：arc4random和arc4random_uniformd
func newRandom() {
    // in参数，则决定了随机数的取值范围
    Double.random(in: 0 ... 1)
    UInt8.random(in: 1 ..< 255)
    Int.random(in: Int.min ... Int.max)
    Bool.random()

    // Collection random
    var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    // randomElement() 返回 T?，空数组返回nil
    let random = numbers.randomElement()!

    // 随机打乱一个集合（unmutating方法），返回一个新数组
    let shuffled = numbers.shuffled()

    // 另外，Swift还提供了一个shuffle()方法，在“原地”打乱集合，修改集合自身：
    numbers.shuffle()

    /// 为自定义类型添加Random方法
    // 实际驱动整个随机数生成算法的，是一个叫做RandomNumberGenerator的协议，它约定了一个next()方法，返回下一个随机数。
    // 而我们之前调用的randomElement()实际上是可以接受一个RandomNumberGenerator类型的参数的。
    // 之所以可以这样调用，是因为这个参数有一个默认值，就是Swift对RandomNumberGenerator的默认实现，叫做Random.default (swift改为[SystemRandomNumberGenerator()])。
    enum Shape: CaseIterable {
        case rectangle
        case circle
        case triangle

        static func random<T: RandomNumberGenerator>(using generator: inout T) -> Shape {
            // inout参数，generator 使用 &, 每次生成随机数之后，生成器自身的值是会修改的
            return allCases.randomElement(using: &generator)!
        }

        static func random() -> Shape {
//            var g = Random.default
            var g = SystemRandomNumberGenerator()
            return random(using: &g)
        }
    }
}
