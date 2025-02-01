//
//  keywords.swift
//  SwiftTutorial
//
//  Created by deerdev on 2023/2/6.
//  Copyright © 2023 deerdev. All rights reserved.
//

import Foundation

/**
 @autoclosure
 @available
 @objc
 @NSCopying
 @NSManaged
 @escaping
 @IBAction
 @IBOutlet
 @discardableResult
 @inline
 @nonobjc
 @UIApplicationMain
 @testable
 @inlinable
 @main
 @_dynamicReplacement
 */

/*
 @inline: 告诉 Swift 编译器在调用函数时内联函数的代码，而不是生成函数调用的代码。这可以提高性能，因为避免了函数调用的开销。
 @nonobjc: 告诉 Swift 编译器不要生成 Objective-C 的运行时兼容性代码。此关键字通常用于 Swift 中的类，结构体或枚举，以告诉编译器不要在 Objective-C 代码中使用该类型。
 @UIApplicationMain: 标识应用程序的主类。编译器将自动生成主函数并在该类的 main 函数中启动应用程序。
 @inlinable: 告诉 Swift 编译器允许函数在多处内联，因此它可以适当地执行优化。此关键字仅适用于公共 API，以提高性能。
 */

/// @inline 和 @inlinable
/*
 @inline 和 @inlinable 都用于告诉 Swift 编译器在调用函数时内联函数的代码，而不是生成函数调用的代码，从而提高应用程序的性能。但它们之间有以下几点区别：

 - 可见性：@inline 可用于任何函数，而 @inlinable 只适用于公共 API。
 - 编译器优化：使用 @inline 标识的函数可能不会内联，因为编译器可以自由决定是否执行内联。相反，使用 @inlinable 标识的函数必须内联，因为它是公共 API。
 - 内联的效果：@inline 的内联效果比 @inlinable 的效果更为有限，因为编译器有权决定是否执行内联。而 @inlinable 的内联效果更明显，因为它是公共 API。
 综上所述，如果需要提高应用程序的性能，建议使用 @inlinable 标识公共 API，而不是使用 @inline 标识任何函数。
 */

@inlinable
public func calculateSum(a: Int, b: Int) -> Int {
    return a + b
}

/// @main 是 Swift 5.3 及更高版本中引入的关键字，用于标识应用程序的入口。
// 使用 @main 的话，就不需要再写一个 main 函数作为应用程序的入口了。编译器将生成默认的 main 函数并调用所有定义为 @main 的函数。因此，您可以通过将所有应用程序逻辑放入 @main 函数来简化应用程序的结构。
/*
 @main
 func runMyApp() {
 print("Starting my app")
 // app logic here
 }
 */

/// @_dynamicReplacement
/*
 @_dynamicReplacement 是 Swift 的一个特殊关键字，用于指示函数或方法可以被动态替换。它的作用是允许您在运行时替换函数或方法的实现，而不需要重新编译应用程序。这有助于提高灵活性和可扩展性，并允许您在不更改代码的情况下修改应用程序的行为。

 例如：

```
@_dynamicReplacement(for: viewDidLoad())
func myDynamicReplacement() {
 // Implement dynamic replacement logic here.
}
 ```

 在此示例中，函数 myDynamicReplacement 是一个 @_dynamicReplacement 函数，它将动态替换 viewDidLoad 方法。因此，当 viewDidLoad 方法被调用时，实际上会执行 myDynamicReplacement 函数。
 */

/// @available
// 声明一个函数在iOS 10.0及以上版本可用
@available(iOS 10.0, *)
func newFeature() {
    // Implementation
}

// 声明一个类在所有平台都不可用
@available(*, unavailable, message: "Use NewClass instead")
class OldClass {
    // Implementation
}

// 声明一个方法在iOS和macOS平台上都有不同的可用性
@available(iOS 11.0, macOS 10.13, *)
func platformSpecificFeature() {
    // Implementation
}

// 指定一个函数被替代
@available(iOS, deprecated: 12.0, renamed: "betterFunction()")
func oldFunction() {
    // Implementation
}
