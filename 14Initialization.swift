//
//  14Initialization.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/2.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 存储属性的初始赋值
// 当你给一个存储属性分配默认值，或者在一个初始化器里设置它的初始值的时候，属性的值就会被直接设置，*** 不会调用任何属性监听器 ***

struct Fahrenheit1 {
    // 直接设置默认值
    var temperature = 32.0
}

/// 构造器
// 使用 init 关键字来写

struct Fahrenheit2 {
    var temperature: Double
    // 初始化
    init() {
        temperature = 32.0
    }
}

// 添加构造参数
struct Celsius {
    var temperatureInCelsius: Double
//    构造参数
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}

/// 参数内部名称 和 外部名称
// 如果你在定义构造器时没有提供参数的外部名字，Swift 会为构造器的每个参数自动生成一个跟内部名字相同的外部名。

struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

// *** 注意，如果不通过外部参数名字传值，无法调用这个构造器的 ***
func testAgumentLabel() {
    // 报编译时错误，需要外部名称(函数标签)
//    let veryGreen = Color(0.0, 1.0, 0.0)
    
    let veryGreen = Color(red: 0.0, green: 1.0, blue: 0.0)
}

/// 无参数标签的构造器参数
// 如果不想为构造器参数提供参数标签，可以用下划线( _ )来显示描述外部名称
struct Celsius2 {
    var temperatureInCelsius: Double
//    init(fromFahrenheit fahrenheit: Double) {
//        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
//    }
//    init(fromKelvin kelvin: Double) {
//        temperatureInCelsius = kelvin - 273.15
//    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
// 直接调用
// let bodyTemperature = Celsius2(37.0)

/// 初始化常量属性 “Assigning Constant Properties During Initialization”
// *** 在构造过程中的 [任意时间点] 给常量属性指定一个值，只要在构造过程 [结束时] 是一个确定的值 ***
// 一旦常量属性被赋值，它将永远不可更改。


/// 默认构造器 Default Initializers

class ShoppingListItem0 {
    var name: String?
    var quantity = 1
    var purchased = false
}
// 变量初始为默认值
var item = ShoppingListItem0()

/// 结构体逐一成员构造器
// 只有结构体
struct Size2 {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size2(width: 2.0, height: 2.0)


/// 【值类型】的构造器代理 “Initializer Delegation for Value Types”
// 在构造器内 调用其他构造器
// *** 如果你为某个[值类型]定义了一个自定义的构造器，你将【无法】访问到默认构造器（如果是结构体，还将无法访问逐一成员构造器） ***
// 这种限制可以防止你为值类型增加了一个额外的且十分复杂的构造器之后,仍然有人错误的使用自动生成的构造器 ***

struct Rect2 {
    var origin = Point()
    var size = Size()
    // 外部无法调用
    init() {}
    // 外部无法调用
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // 调用其他构造器
        // *** self.init 只能在 构造器 内部使用 ***
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// *****类*****

/// 类的继承和初始化 “Class Inheritance and Initialization”

/// 指定构造器 Designated Initializers
// 指定构造器是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类的构造器来实现父类的初始化。
// 每个类至少得有一个指定构造器

/// 便利构造器 Convenience Initializers
// 便利构造器是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。
// 你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例。
// 必要的时候为类提供便利构造器，比方说 某种情况下通过使用便利构造器来快捷调用某个指定构造器，能够节省更多开发时间并让类的构造过程更清晰明了。

class DCInitialization {
    // 指定构造器
    init(parameters: Int) {
//        statements
    }
    
    // 便利构造器 关键字【convenience】
    convenience init(parameters: Double) {
//        statements
        self.init(parameters: Int(parameters))
    }
}

/**
 
* 规则 1
指定构造器必须调用其直接父类的的指定构造器。

* 规则 2
便利构造器必须调用同类中定义的其它构造器。

* 规则 3
便利构造器必须最终导致一个指定构造器被调用。

- 指定构造器必须总是向上代理
- 便利构造器必须总是横向代理
 
**/

/// 两段式构造过程 Two-Phase Initialization
// 第一个阶段，每个存储型属性被引入它们的类指定一个初始值。当每个存储型属性的初始值被确定后
// 第二阶段开始，它给每个类一次机会，在新实例准备使用之前进一步定制它们的存储型属性

// *** 便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖 ***


/// 构造器的继承和重写 “Initializer Inheritance and Overriding”
// “Swift 中的子类默认情况下不会继承父类的构造器”
// *** 当你重写一个父类的指定构造器时，你总是需要写【override】修饰符 ***
// 只重写父类的 指定构造器 ，因为便利构造器是横向的
// 可以把父类的指定构造器 重写为 便利构造器
// 在子类中“重写”一个父类便利构造器时，不需要加override前缀。
class Vehicle1 {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class Bicycle: Vehicle1 {
    // 重写构造器
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
// ** 子类可以在初始化时修改继承来的变量属性，但是不能修改继承来的常量属性。 **


/// 自动继承（父类）构造器 Automatic Initializer Inheritance

/**
- 规则1
如果子类没有定义任何指定构造器，它将自动继承所有父类的【指定构造器】。

- 规则2
如果子类提供了所有父类[指定构造器]的实现————无论是通过规则1继承过来的，还是提供了自定义实现—————它将自动继承所有父类的【便利构造器】。

即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。

**/

// 对于规则2，子类可以将父类的[指定构造器]实现为【便利构造器】。

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        // 调用父类构造器
        super.init(name: name)
    }
    
    // 与父类同名，重写（成 便利构造器）
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    // 继承所有父类的 指定和便利构造器（规则1和规则2）
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}


/// 可失败构造器 Failable Initializers
// 其语法为在init关键字后面添加问号 (init?) ———— 可选类型
// *** 可失败构造器的参数名和参数类型，不能与其它非可失败构造器的参数名，及其参数类型相同。 ***
// 处理某些属性 不可赋空值 的情况

struct Animal {
    let species: String
    
    init?(species: String) {
        // 只有 return nil
        if species.isEmpty { return nil }
        
        self.species = species
    }
}
// 处理可选类型
let anonymousCreature = Animal(species: "")


/// 枚举类型的可失败构造器 Failable Initializers for Enumerations
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            // 返回失败
            return nil
        }
    }
}

/// 带原始值的枚举类型的可失败构造器 Failable Initializers for Enumerations with Raw Values
// 带原始值的枚举类型会【自带】一个可失败构造器 init?(rawValue:)
enum TemperatureUnit2: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

func enumTest() {
    // 默认可失败构造器
    let fahrenheitUnit = TemperatureUnit2(rawValue: "F")
    
    if fahrenheitUnit != nil {
        print("This is a defined temperature unit, so initialization succeeded.")
    }
}

/// 构造失败的传递 “Propagation of Initialization Failure”
// 类，结构体，枚举的可失败构造器可以横向代理到类型中的其他可失败构造器。
// 类似的，子类的可失败构造器也能向上代理到父类的可失败构造器

class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        // 向上 调用父类 可失败构造器
        super.init(name: name)
    }
}

/// 重写一个可失败构造器 “Overriding a Failable Initializer”
// “在子类中重写父类的可失败构造器”
// 也可以用子类的[非可失败构造器]重写一个父类的[可失败构造器] (反之 不可)。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败。

class Document {
    var name: String?
    // this initializer creates a document with a nil name value
    init() {}
    // this initializer creates a document with a non-empty name value
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    // 重写成不可失败构造器
    override init(name: String) {
        super.init()
        
        // 强制解包 判断
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

/// 可失败构造器 init! “The init! Failable Initializer”
// 该可失败构造器将会构建一个对应类型的 [隐式解包] 可选类型的对象。

// 你可以在init?中代理到init!，反之亦然。
// 你也可以用init?重写init!，反之亦然。
// 你还可以用init代理到init!，不过，一旦init!构造失败，则会触发一个断言。


/// 必要构造器 Required Initializers
// 【required】修饰符表明所有该类的子类都 必须 实现该构造器：
class SomeRequireClass {
    required init() {
        // 构造器的实现代码
    }
}

// 子类重写父类的必要构造器时，必须在子类的构造器前也添加required修饰符，不用override



/// 通过闭包和函数来设置属性的默认值 “Setting a Default Property Value with a Closure or Function”

class SomeClosureClass {
    let someProperty: Int = {
        // create a default value for someProperty inside this closure
        // someValue must be of the same type as SomeType
        var someValue = 0;
        return someValue
    }() // 闭包花括号的结尾跟一个没有参数的圆括号()。这是告诉 Swift 立即执行闭包，而不是赋值一个闭包
}

// *** 闭包执行时，不能访问self ***
// *** 如果你使用了闭包来初始化属性，请记住闭包执行的时候，实例的其他部分还没有被初始化。
// *** 这就意味着你不能在闭包里读取任何其他的属性值，即使这些属性有默认值。你也不能使用[隐式 self 属性]，或者调用实例的方法。











