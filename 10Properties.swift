//
//  10Properties.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/29.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// Swift中的属性 统一了 OC中的属性和实例方法

/// 存储属性 Stored Properties
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

/// 延迟存储属性
// 延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用 【lazy】 来标示一个延迟存储属性
// ***必须将延迟存储属性声明成变量（使用 var 关键字）***
// *** 如果一个被标记为 lazy 的属性在没有初始化时就同时被"多个线程"访问，则无法保证该属性只会被初始化一次 ***
class DataImporter {
    /*
     DataImporter 是一个负责将外部文件中的数据导入的类。
     这个类的初始化会消耗不少时间。
     */
    var fileName = "data.txt"
    // 这里会提供数据导入功能
}

class DataManager {
    // 懒加载属性
    lazy var importer = DataImporter()
    var data = [String]()
    // 这里会提供数据管理功能
}

func lazyValueTest() {
    let manager = DataManager()
    manager.data.append("Some data")
    manager.data.append("Some more data")
    // DataImporter 实例的 importer 属性还没有被创建
}

/// 计算属性 Computed Properties
// “类、结构体和枚举可以定义计算属性”
// 计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    // 计算属性
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

func computedPropTest() {
    var square = Rect(
        origin: Point(x: 0.0, y: 0.0),
        size: Size(width: 10.0, height: 10.0))
    let initialSquareCenter = square.center
    square.center = Point(x: 15.0, y: 15.0)
    print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
    // 打印 "square.origin is now at (10.0, 10.0)”
}

/// 简化setter的声明
// 计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 newValue
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            // 使用newValue来代替传递的值
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

/// 只读计算属性
// 只有 getter 没有 setter 的计算属性就是只读计算属性
// “必须使用 var 关键字定义计算属性，包括只读计算属性，因为它们的值不是固定的”
// “只读计算属性的声明可以去掉 get 关键字和花括号”
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        // 直接简化get
        return width * height * depth
    }
}

/// 属性观察器
// 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。
// *** 可以为除了【延迟存储属性】之外的其他存储属性添加属性观察器 ***

// *** 如果将属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值
class StepCounter {
    var totalSteps: Int = 0 {
        // willSet 观察器会将新的属性值作为常量参数传入，在 willSet 的实现代码中可以为这个参数指定一个名称，如果不指定则参数仍然可用，这时使用默认名称 newValue 表示。
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        //同样，didSet 观察器会将旧的属性值作为参数传入，可以为该参数命名或者使用默认参数名 oldValue。如果在 didSet 方法中再次对该属性赋值，那么新值会覆盖旧的值。
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }

            // 在 didSet 属性观察器将 属性值 再次赋值时，[不会]造成属性观察器被再次调用。
            totalSteps = 0
        }
    }
}

/// 全局的常量或变量 都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。

/// 类属性
// 类型属性用于定义某个类型所有实例共享的数据，类C语言静态常量
// 存储型类属性 可以是变量或常量，
// 计算型类属性 跟实例的计算型属性一样只能定义成变量属性。

// 跟实例的存储型属性不同，必须给 存储型类属性 指定默认值 (因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值)
// 存储型类属性 是延迟初始化的，它们只有在 第一次 被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其 进行一次 初始化，并且不需要对其使用 lazy 修饰符。

// 使用 static 关键字
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClasses {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    // 针对计算型类属性，使用关键字 class 来支持子类对父类的实现进行重写
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

// 访问类属性: 类名.属性( SomeStructure.storedTypeProperty )

/// 属性包装器
// 在存储和定义属性的代码之间添加了一个分隔层，wrappedValue为真实值
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number = 0
    /// 从属性包装器中呈现一个值 「包装器的被呈现值」，用于跟踪属性包装器在存储新值之前是否调整了该新值。（是否被包装器调整过）
    // 通过 $<name> 访问
    private(set) var projectedValue: Bool
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
    //    var wrappedValue: Int {
    //        get { return number }
    //        set { number = min(newValue, 12) }
    //    }

    /// 设置被包装属性的初始值
    // 初始化构造器
    init() {
        maximum = 12
        number = 0
        projectedValue = false
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
        projectedValue = false
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
        projectedValue = false
    }
}

struct SmallRectangle {
    // 被包裹属性最大不超过 12
    // 使用 init() 构造器
    @SmallNumber var height: Int
    @SmallNumber var width: Int

    // 使用 init(wrappedValue:) 构造器
    @SmallNumber var height1: Int = 1
    @SmallNumber var width1: Int = 1

    // 使用 init(wrappedValue:maximum:) 构造器:
    @SmallNumber(wrappedValue: 2, maximum: 5) var height2: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width2: Int
    // 当包含属性包装器实参时，你也可以使用赋值来指定初始值。
    @SmallNumber(maximum: 9) var width3: Int = 2  // 依然使用 init(wrappedValue:maximum:) 构造器
}

func testSomeStructure() {
    struct SomeStructure {
        @SmallNumber var someNumber: Int
    }
    var someStructure = SomeStructure()
    someStructure.someNumber = 4
    /// 使用同名 + $ 前缀，访问 「包装器的被呈现值」，值小，没有被包装器调整过
    print(someStructure.$someNumber)
    // 打印 "false", projectedValue=false

    someStructure.someNumber = 55  // 值大，被包装器调整过
    print(someStructure.$someNumber)
    // 打印 "true", projectedValue=true
}

/// 属性包装器 也可以用于全局变量和局部变量。
// 全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量。
func someFunction() {
    @SmallNumber var myNumber: Int = 0

    myNumber = 10
    // 这时 myNumber 是 10

    myNumber = 24
    // 这时 myNumber 是 12
}
