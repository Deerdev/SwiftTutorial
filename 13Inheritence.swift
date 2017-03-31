//
//  13Inheritence.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/3/31.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

class SomeSuperclass {
    // 父类
}
/// 定义一个子类
class SomeChildClass: SomeSuperclass {
    // 这里是子类的定义
}

/// 重写方法
// 如果要重写某个特性，你需要在重写定义的前面加上【override】关键字
// 可以通过使用【super】前缀来访问超类版本的方法，包括下标super[index]
// Accessing Superclass Methods, Properties, and Subscripts
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // 什么也不做-因为车辆不一定会有噪音
    }
}

class Train: Vehicle {
    override func makeNoise() {
        super.makeNoise();
        
        print("Choo Choo")
    }
}

/// 重写属性
// 修改属性的setter和getter方法
// 子类并不知道继承来的属性是存储型的还是计算型的，它只知道继承来的属性会有一个名字和类型。
// 在重写一个属性时，必需将它的 名字和类型 都写出来。这样才能使编译器去检查你重写的属性是与超类中同名同类型的属性相匹配的。

// *** 可以将一个继承来的[只读]属性重写为一个[读写]属性，只需要在重写版本的属性里提供 getter 和 setter 即可 ***
// *** 但是，你 不可以 将一个继承来的[读写]属性重写为一个[只读]属性 ***
class Car: Vehicle {
    var gear = 1
    
    override var description: String {
        // 返回 父类属性 + ...
        return super.description + " in gear \(gear)"
    }
}

/// 重写属性观察器 Overriding Property Observers
// 不可以 为继承来的 [常量存储]型属性或 继承来的[只读计算]型属性添加属性观察器
// *** 不可以 同时提供重写的 setter 和重写的 属性观察器 ***(在setter中也可以观察)

/// 防止重写 Preventing Overrides
// 可以通过把方法，属性或下标标记为【final】来防止它们被重写 （例如：final var，final func，final class func，以及final subscript）
// 关键字class前添加final修饰符（final class）来将整个类标记为 final 的，这样的类是不可被继承













