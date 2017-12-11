//
//  16AutomaticReferenceCounting.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/2.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 解决循环引用
// “通过定义类之间的关系为弱引用或无主引用，以替代强引用”

// *** 当其他的实例有更短的生命周期时，使用弱引用，也就是说，当其他实例析构在先
// *** 当其他实例有相同的或者更长生命周期时，请使用无主引用

/// 弱引用（ weak reference ）
// 被声明为可选类型
// 在 ARC 给弱引用设置 nil 时 不会 调用属性观察者

class PersonMan {
    let name: String
    init(name: String) { self.name = name }
    
    // 可选类型
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    
    // weak 可选类型
    weak var tenant: PersonMan?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

/*** 对比 ARC 和 垃圾回收机制 ***
 
 * 在使用垃圾收集的系统里，弱指针有时用来实现简单的缓冲机制，因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁。
 
 * 但是在 ARC 中，一旦值的最后一个强引用被移除，就会被立即销毁，这导致弱引用并不适合上面的用途

 **/


/// 无主引用（ unowned reference )
// 非可选类型，始终得有值
// ARC 无法在实例被释放后将无主引用设为 nil ，因为非可选类型的变量不允许被赋值为 nil 。
// 试图在实例的被释放后访问无主引用，将触发运行时错误。只有在确保该引用会一直引用实例的时候 才使用无主引用。


class Customer {
    let name: String
    
    // Customer销毁后 CreditCard也会被销毁
    // 可选类型
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    
    // creditCard 在生命周期内 会一直 被Customer 拥有
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

/// 不安全的 无主引用
// 你可以通过 unowned(unsafe) 来声明不安全无主引用。
// 如果你试图在实例被销毁后，访问该实例的不安全无主引用，你的程序会尝试访问该实例 之前所在的内存地址，这是一个不安全的操作。


/// 无主引用以及隐式解析可选属性 “Unowned References and Implicitly Unwrapped Optional Properties”

// Person 和 Apartment 的例子展示了两个属性的值都允许为 nil ，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。
// Customer 和 CreditCard 的例子展示了一个属性的值允许为 nil ，而另一个属性的值不允许为 nil ，这也可能导致循环强引用。这种场景最好使用无主引用来解决。

// ** 还有第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为 nil 。
// ** 在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析的可选属性。
class Country {
    let name: String
    
    // 隐式解析，可选类型 （因为初始化后，肯定有值）每个国家必有一个首都
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    // 无主引用
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}


/// 闭包的循环强引用 “Strong Reference Cycles for Closures”
// 循环引用 发生在： “当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时”
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        // 闭包内强引用 self
        // 尽管闭包多次引用了 self ，它只捕获 HTMLElement 实例的一个强引用。
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}
/// 解决闭包循环强引用 “Resolving Strong Reference Cycles for Closures”
// Swift 要求你在闭包中引用self成员时使用 self.someProperty 或者 self.someMethod （而不只是 someProperty 或 someMethod ）。这有助于提醒你可能会一不小心就捕获了 self 。

/// 定义捕获列表 “Defining a Capture List”
// 捕获列表：定义了当在闭包体里捕获一个或多个引用类型的规则
// 捕获列表中的每一项都由 weak 或 unowned 关键字与类实例的引用（如 self ）或初始化过的变量（如 delegate = self.delegate! ）成对组成

class weakClosure {
    var delegate: HTMLElement?
    init(delegate: HTMLElement) {
        self.delegate = delegate;
    }
    
    lazy var someClosure: (Int, String) -> String = {
        // 捕获列表
        [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
        // closure body goes here
        return ""
    }
    
    lazy var someClosure2: ()-> String = {
        // 闭包没有参数时
        [unowned self, weak delegate = self.delegate!] in
        // closure body goes here
        return ""
    }
}

/// 捕获列表 弱引用 和 无主引用 的区分
/// 捕获弱引用 是一个Optional类型
// 在闭包和捕获的实例总是 互相引用并且总是同时释放 时，将闭包内的捕获定义为【无主引用】。

// 相反，在被捕获的引用可能会变为 nil 时，定义一个【弱引用】的捕获 （弱引用 总是可选类型，在闭包内需要检查）
// “如果被捕获的引用绝对不会变为nil，应该用无主引用，而不是弱引用”

// ** unowned 类似assign，在对象释放后 不会被置为nil，而是成为野指针
class HTMLElementSafe {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        // 添加捕获列表
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}





