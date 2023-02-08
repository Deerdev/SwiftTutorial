//
//  24AccessControl.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/5.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation


/// “Modules and Source Files”
/// 模块: Xcode 的每个目标（例如框架或应用程序）都被当作独立的模块处理
/// 源文件: 就是 Swift 中的源代码文件


/// 1.访问级别 Access Levels

/**
 * 开放访问和公开访问(open / public): 可以访问同一模块源文件中的任何实体，在模块外也可以通过导入该模块来访问源文件里的所有实体。通常情况下，框架中的某个接口可以被任何人使用时，你可以将其设置为开放或者公开访问。
 *         内部访问(internal): 可以访问同一模块源文件中的任何实体，但是不能从模块外访问该模块源文件中的实体。通常情况下，某个接口只在应用程序或框架内部使用时，你可以将其设置为内部访问。
 *      文件私有访问(file-private): 访问 将实体的使用限制于当前定义源文件中。当一些细节在整个文件中使用时，使用 file-private 访问隐藏特定功能的实现细节。
 *         私有访问(private): 限制实体只能在所定义的作用域内使用。需要把这些细节被整个作用域使用的时候，使用文件私有访问隐藏了一些特定功能的实现细节。
 **/

/// open / public的区别
// “开放访问只作用于类类型和类的成员”

// * public 访问，或任何更严格的访问级别的类，只能在其定义模块中被继承。
// * public 访问，或任何更严格访问级别的类成员，只能被其定义模块的子类重写。
// * open 类可以在其定义模块中被继承，也可在任何导入定义模块的其他模块中被继承。
// * open 类成员可以被其定义模块的子类重写，也可以被导入其定义模块的任何模块重写。
// * 显式地标记类为 open 意味着你考虑过其他模块使用该类作为父类对代码的影响，并且相应地设计了类的代码。

/// 2.访问级别基本原则 “Guiding Principle of Access Levels”
// Swift 中的访问级别遵循一个基本原则：不可以在某个实体中定义访问级别更低（更严格）的实体。

// 例如：
//
// 一个公开访问级别的变量，其类型的 访问级别 不能是内部，文件私有或是私有类型的。因为无法保证变量的类型在使用变量的地方也具有访问权限。
// 函数的访问级别 不能高于它的 参数类型和返回类型 的访问级别。因为这样就会出现函数可以在任何地方被访问，但是它的参数类型和返回类型却不可以的情况。

/// 3.默认访问级别 (Default Access Levels)
//  internal

/// 4.单元测试访问级别 “Access Levels for Unit Test Targets”
// 如果在导入应用程序模块的语句前使用 【@testable】 特性，然后在允许测试的编译设置（Build Options -> Enable Testability）下编译这个应用程序模块，
// 单元测试目标就可以访问应用程序模块中所有内部级别的实体。


/// 5.访问控制语法 Access Control Syntax

// public      class SomePublicClass {}
// internal    class SomeInternalClass {}
// fileprivate class SomeFilePrivateClass {}
// private     class SomePrivateClass {}
//
// public      var somePublicVariable = 0
// internal    let someInternalConstant = 0
// fileprivate func someFilePrivateFunction() {}
// private     func somePrivateFunction() {}


/// 6.自定义类型 Custom Types
// 将类型指定为 [私有或者文件私有] 级别，那么该类型的所有成员的默认访问级别也会变成 [私有或者文件私有] 级别。
// 将类型指定为 [公开或者内部访问] 级别（或者不明确指定访问级别，而使用默认的内部访问级别），那么该类型的所有成员的默认访问级别将是 [内部访问]
public class SomePublicClass {                  // 显式公开类
    public var somePublicProperty = 0            // 显式公开类成员
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

class SomeInternalClass {                       // 隐式内部类
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

fileprivate class SomeFilePrivateClass {        // 显式文件私有类
    func someFilePrivateMethod() {}              // 隐式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

private class SomePrivateClass {                // 显式私有类
    func somePrivateMethod() {}                  // 隐式私有类成员
}


/// 7.元组类型 Tuple Types
// 由元组中访问级别 最严格的类型 指定
// 只能推断，不可明确指定

/// 8.函数类型 Function Types
// 函数的访问级别根据访问级别 最严格的 参数类型 或 返回类型 的访问级别来决定

// *** 如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要【明确地指定】该函数的访问级别 ***


// 函数的返回 元组 是private的，而函数默认返回internal
// 因为 private小于internal的限制，必须明确声明，（函数明确加上 private）
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    // function implementation goes here
    return (SomeInternalClass(), SomePrivateClass())
}


/// 9.枚举类型 Enumeration Types
// 枚举成员的访问级别和该枚举类型相同，你 不能为枚举成员 单独指定不同的访问级别。
// 枚举定义中的任何 原始值或关联值 的类型的访问级别至少 不能低于 枚举类型的访问级别
public enum CompassPoint5 {
    // 枚举成员都是public
    case north
    case south
    case east
    case west
}

/// 10.嵌套类型 Nested Types
// 嵌套类型默认 和 外部类型 的访问限制（private 和 internal）一致，public需要明确指定
// 如果想让嵌套类型拥有 public 访问级别，那么需要[明确指定]该嵌套类型的访问级别


/// 11.子类 Subclassing
// 子类的访问级别 不高于 父类

// *** 之类可以重写 父类的方法，提高访问级别 ***
public class A {
    fileprivate func someMethod() {}
}
internal class B: A {
    // fileprivate --> internal
    override internal func someMethod() {}
}

// *** 用子类成员去访问访问级别更低的父类成员 *** 
// (可以访问的范围：在同一【源文件】中访问父类 private 级别的成员，在同一【模块】内访问父类 internal 级别的成员）
public class C {
    fileprivate func someMethod() {}
}
internal class D: C {
    override internal func someMethod() {
        super.someMethod()
    }
}

/// 12.常量 变量 属性 下标 “Constants, Variables, Properties, and Subscripts”
// 常量、变量、属性 不能拥有比它们的类型更高的访问级别
// 如果常量、变量、属性、下标的类型是 private 级别的，那么它们【必须明确指定】访问级别为 private


// “常量、变量、属性、下标的 Getters 和 Setters 的访问级别和它们所属类型的访问级别【相同】
// 可以为Setter降低访问控制：通过 fileprivate(set)、private(set) 或 internal(set) 为它们的写入权限指定更低的访问级别，变成只读

public struct TrackedString {
    // private的Setter，外部只能读，不能写
    // 在源文件内部 可以写 numberOfEdits 变量
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}


/// 13.构造器 Initializers
// 自定义构造器 的访问级别可以【低于或等于】其所属类型的访问级别
// 必要构造器，它的访问级别 必须 和所属类型的访问级别【相同】

/// 14.无参默认构造器 Default Initializers
// 如果一个类型被指定为 public 级别，那么默认构造器的访问级别将为 internal。
// 如果你希望一个 public 级别的类型也能在其他模块中使用这种 无参数的默认构造器，只能【自己提供】一个 public 访问级别的无参数构造器。


/// 15.结构体默认的成员逐一构造器 “Default Memberwise Initializers for Structure Types”

// 如果结构体中【任意存储型属性】的访问级别为 private，那么该结构体默认的成员逐一构造器的访问级别就是 private。
// 否则，这种构造器的访问级别依然是 internal

/// 16.协议 Protocols
// 可以在定义协议时，指定访问级别
// 协议中的每一个 要求 都具有和该协议相同的访问级别
// *** 如果你定义了一个 public 访问级别的协议，那么该协议的所有实现也会是 【public】 访问级别 ***
// *** 这一点不同于其他类型，例如，当类型是 public 访问级别时，其成员的访问级别却只是 【internal】 ***

/// 17.协议继承 Protocol Inheritance
//  如果定义了一个继承自其他协议的 新协议，那么新协议拥有的访问级别 最高 也只能和被继承协议的访问级别 相同

/// 18.协议一致性 Protocol Conformance
// 一个类型可以采纳比自身访问级别低的协议
// 如果一个类型是 public 级别，采纳的协议是 internal 级别，那么采纳了这个协议后，该类型作为符合协议的类型时，其访问级别也是 internal。

// 一个 public 级别的类型，采纳了 internal 级别的协议，那么协议的实现至少也得是 internal 级别。


/// 19.扩展 Extensions
// 在访问级别允许的情况下对类、结构体、枚举进行扩展。 
// 扩展成员 具有和原始类型成员【一致】的访问级别

// 可以明确指定扩展的访问级别（例如，private extension），从而给该扩展中的所有成员指定一个新的默认访问级别。这个新的默认访问级别 仍然可以被单独指定的访问级别所【覆盖】。

/// 20.通过扩展添加协议一致性(Adding Protocol Conformance with an Extension)
// 通过 扩展来采纳协议，那么你就不能显式指定该扩展的访问级别了。【协议拥有相应的访问级别】


/// 21.类型别名 Type Aliases
// 类型别名的访问级别 小于类型本身的访问级别


