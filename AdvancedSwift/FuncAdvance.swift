//
//  FuncAdvance.swift
//  SwiftTutorial
//
//  Created by deerdev on 2018/8/9.
//  Copyright © 2018年 deerdev. All rights reserved.
//

import Foundation

/*
 0. 如果你将闭包作为参数传递，并且你不再⽤这个闭包做其他事情的话，就没有必要现将 它存储到⼀个局部变量中。可以想象⼀下⽐如 5*i 这样的数值表达式，你可以把它直接 传递给⼀个接受 Int 的函数，⽽不必先将它计算并存储到变量⾥。

 1. 如果编译器可以从上下⽂中推断出类型的话，你就不需要指明它了。在我们的例⼦中， 从数组元素的类型可以推断出传递给 map 的函数接受 Int 作为参数，从闭包的乘法结果 的类型可以推断出闭包返回的也是 Int。

 2. 如果闭包表达式的主体部分只包括⼀个单⼀的表达式的话，它将⾃动返回这个表达式的 结果，你可以不写 return。

 3. Swift 会⾃动为函数的参数提供简写形式，$0 代表第⼀个参数，$1 代表第⼆个参数，以 此类推。

 4. 如果函数的最后⼀个参数是闭包表达式的话，你可以将这个闭包表达式移到函数调⽤的 圆括号的外部。这样的尾随闭包语法在多⾏的闭包表达式中表现⾮常好，因为它看起来 更接近于装配了⼀个普通的函数定义，或者是像 if (expr) { } 这样的执⾏块的表达形式。

 5. 最后，如果⼀个函数除了闭包表达式外没有别的参数，那么⽅法名后⾯的调⽤时的圆括 号也可以⼀并省略。
 */

func swiftFuncFeatures() {
    [1, 2, 3].map( { (i: Int) -> Int in return i * 2 } )
    [1, 2, 3].map( { i in return i * 2 } )
    [1, 2, 3].map( { i in i * 2 } )
    [1, 2, 3].map( { $0 * 2 } )
    [1, 2, 3].map() { $0 * 2 }
    [1, 2, 3].map { $0 * 2 }

    // 不关心 _ 参数
    (0..<3).map { _ in arc4random() } // [1858046851, 3436133829, 1808204593]
}

/// @objcMembers 所有成员将在 OC中可见
@objcMembers final class Person0: NSObject {

    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
}


func PersonSort() {
    let people = [
        Person0(first: "Emily", last: "Young", yearOfBirth: 2002),
        Person0(first: "David", last: "Gray", yearOfBirth: 1991),
        Person0(first: "Robert", last: "Barnes", yearOfBirth: 1985),
        Person0(first: "Ava", last: "Barnes", yearOfBirth: 2000),
        Person0(first: "Joanne", last: "Miller", yearOfBirth: 1994),
        Person0(first: "Ava", last: "Barnes", yearOfBirth: 1998),
        ]

    /// OC的排序
    let lastDescriptor = NSSortDescriptor(key: #keyPath(Person0.last), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
    let firstDescriptor = NSSortDescriptor(key: #keyPath(Person0.first), ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))

    let yearDescriptor = NSSortDescriptor(key: #keyPath(Person0.yearOfBirth), ascending: true)

    let descriptors = [lastDescriptor, firstDescriptor, yearDescriptor]
    (people as NSArray).sortedArray(using: descriptors)
    /* [Ava Barnes (1998), Ava Barnes (2000), Robert Barnes (1985), David Gray (1991), Joanne Miller (1994), Emily Young (2002)] */

    /// swift实现上述排序
    people.sorted { p0, p1 in
        let left = [p0.last, p0.first]
        let right = [p1.last, p1.first]
        return left.lexicographicallyPrecedes(right) {
            $0.localizedStandardCompare($1) == .orderedAscending
        }
    }
    /* [Ava Barnes (2000), Ava Barnes (1998), Robert Barnes (1985), David Gray (1991), Joanne Miller (1994), Emily Young (2002)] */

    /// 对可选型的排序
    /*
    var files = ["one", "file.h", "file.c", "test.h"]
    files.sort { l, r in
        r.fileExtension.flatMap { l.fileExtension?.localizedStandardCompare($0) } == .orderedAscending
    }
    // ["one", "file.c", "file.h", "test.h"]
    */


}

/// =========== inout 参数和可变方法 ==============
// 如果你有⼀些 C 或者 C++ 背景的话，在 Swift 中 inout 参数前⾯使⽤的 & 符号可能会给你⼀种 它是传递引⽤的印象。但事实并⾮如此，inout 做的事情是通过值传递，然后复制回来，⽽并不 是传递引⽤。
// > inout 参数将⼀个值传递给函数，函数可以改变这个值，然后将原来的值替换掉，并 从函数中传出(但是 编译器可能会优化成引用传入)

// inout 传入的必须是一个 可以修改(var)的 lvalue（左值）

postfix func ++(x: inout Int) { x += 1 }

func inoutTest() {

    var dictionary = ["one": 1]
    // 对字典添加操作...
    dictionary["one"]?++
    // Optional(2)
    // dictionary["one"]
}

/// 嵌套函数 内 可以修改 inout
func incrementTenTimes(value: inout Int) {
    func inc() { value += 1 }
    for _ in 0..<10 { inc() }  //
}
/*
var x = 0
incrementTenTimes(value: &x) // 10
*/

/// inout变量不能逃逸
func escapeIncrement(value: inout Int) -> () -> () {
    func inc() { value += 1 }
    // error: 嵌套函数不能捕获 inout 参数
//    return inc
    return {}
}

/// & 可能传入就是 指针
// 传入不安全的指针
func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int { // 将指针的的复制存储在闭包中
    return {
        pointer.pointee += 1
        return pointer.pointee }
}

func pointReference() {
    let fun: () -> Int
    do {
        var array = [0]
        fun = incref(pointer: &array)
    }
    // arrray已经被销毁，所以传入指针 变为野指针；返回的值 不可预知
    fun()
}

/// ======== 结构体的 延迟属性 =====

struct PointFunc {
    var x: Double
    var y: Double
    private(set) lazy var distanceFromOrigin: Double = (x*x + y*y).squareRoot()

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

func testPointFunc() {
    // 赋值之后，distanceFromOrigin就不会改变
    var point = PointFunc(x: 3, y: 4)
    point.distanceFromOrigin // 5.0
    point.x += 10
    point.distanceFromOrigin // 5.0

    // 如果把distanceFromOrigin定义为 mutating 操作，那么结构体也要定义为 可变量(var)
    /*
    let immutablePoint = PointFunc(x: 3, y: 4)
    immutablePoint.distanceFromOrigin          // 错误：不能在⼀个不可变量上使⽤可变 getter
    */
}


/// ============ 泛型 下标 ===========

extension Dictionary {
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get { return self[key] as? Result }
        set {
            guard let value = newValue as? Value else { return }
            self[key] = value
        }
    }
}

func subscriptForGenerics() {
    var japan: [String: Any] = [
        "name": "Japan", "capital": "Tokyo", "population": 126_740_000, "coordinates": [
            "latitude": 35.0,
            "longitude": 139.0 ]
    ]

    // 错误：类型 'Any' 没有下标成员
    // japan["coordinate"]?["latitude"] = 36.0
    // 错误：不能对不可变表达式赋值
    // *** 转换类型之后 就无法对原值 赋值
    // (japan["coordinates"] as? [String: Double])?["coordinate"] = 36.0

    /// 添加新的下标方法，实现类型判断
    japan["coordinates", as: [String: Double].self]?["latitude"] = 36.0
    // japan["coordinates"]
    // Optional(["latitude": 36.0, "longitude": 139.0])
}

/// ============ 键路径 ===========
/// 键路径可以由任意的存储和计算属性组合⽽成，其中还可以包括可选链操作符。
/// 编译器会⾃动 为所有类型⽣成 [keyPath:] 的下标⽅法。你通过这个⽅法来 “调⽤” 某个键路径。对键路径的调 ⽤，也就是在某个实例上访问由键路径所描述的属性。
// 获取键路径：\PersonPath.address.street
struct AddressPath {
    var street: String
    var city: String
    var zipCode: Int
}

struct PersonPath {
    let name: String
    var address: AddressPath
}

func keypathTest() {

    /// KeyPath<Person, String> 键路径是强类型的，它表⽰该键路径可以作⽤于 Person，并 返回⼀个 String。
    /// streetKeyPath 是⼀个 WritableKeyPath，这是因为构成这个键路径的所 有属性都是[可变的]，所以这个可写键路径本⾝允许其中的值发⽣变化
    let streetKeyPath = \PersonPath.address.street // WritableKeyPath<Person, String>
    let nameKeyPath = \PersonPath.name // KeyPath<Person, String>

    let simpsonResidence = AddressPath(street: "1094 Evergreen Terrace", city: "Springfield", zipCode: 97475)
    var lisa = PersonPath(name: "Lisa Simpson", address: simpsonResidence)
    lisa[keyPath: nameKeyPath] // Lisa Simpson
    // WritableKeyPath：可变的键值
    lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"

    /// 键路径 还可以拼接
    // KeyPath<Person, String> + KeyPath<String, Int> = KeyPath<Person, Int>
    let nameCountKeyPath = nameKeyPath.appending(path: \.count) // Swift.KeyPath<Person, Swift.Int>
}

/// 可以通过函数建模的键路径
// ⼀个将基础类型 Root 映射为类型为 Value 的属性的键路径，和⼀个具有 (Root) -> Value 类型 的⽅法⼗分类似
// 键路径除了在语法上更简洁外，最⼤的优势在于它们是【值】。你可以测试键路径是 否相等，也可以将它们⽤作字典的键 (因为它们遵守 Hashable)。另外，不像函数，键路径是不 包含状态的，所以它也不会捕获可变的状态。

/// 可写键路径
// 可写的键路径⽐较特殊：你可以⽤它来读取或者写⼊⼀个值。因此，它和⼀对函数等效：⼀个 负责获取属性值 ((Root) ->Value)，另⼀个负责设置属性值 ((inout Root, Value) -> Void)

func writeKeyPath() {
    let simpsonResidence = AddressPath(street: "1094 Evergreen Terrace", city: "Springfield", zipCode: 97475)
    var person = PersonPath(name: "Lisa Simpson", address: simpsonResidence)

    let streetKeyPath = \PersonPath.address.street

    /// 可写键路径 和 get/set 方法一致
    let getStreet: (PersonPath) -> String = { person in
        return person.address.street
    }

    let setStreet: (inout PersonPath, String) -> () = { person, newValue in
        person.address.street = newValue
    }
}

/// ============ 键路径实现 双向绑定 ===========

// NSObjectProtocol 协议 就可以使用 Self
// KeyPath
// ReferenceWritableKeyPath
// ReferenceWritableKeyPath 和 WritableKeyPath 很相似，不过它可以让我们对 (other 这样的) 使⽤ let 声明的引⽤变量进⾏写操作（因为持有的是 引用）
extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>, writeTo other: Other, _ otherKeyPath: ReferenceWritableKeyPath<Other, A>) -> NSKeyValueObservation where A: Equatable, Other: NSObjectProtocol {
        return observe(keyPath, options: .new) { _, change in
            guard let newValue = change.newValue, other[keyPath: otherKeyPath] != newValue else {
                return // prevent endless feedback loop
            }
            other[keyPath: otherKeyPath] = newValue
        }
    }
}

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self,A>, to other: Other, _ otherKeyPath: ReferenceWritableKeyPath<Other,A>) -> (NSKeyValueObservation, NSKeyValueObservation) where A: Equatable, Other: NSObject {

        let one = observe(keyPath, writeTo: other, otherKeyPath)
        let two = other.observe(otherKeyPath, writeTo: self, keyPath)
        return (one,two)
    }
}

final class Sample: NSObject { @objc dynamic var name: String = "" }

class MyObj: NSObject { @objc dynamic var test: String = "" }

func bindEachOther() {
    let sample = Sample()
    let other = MyObj()
    let observation = sample.bind(\Sample.name, to: other, \.test)
    sample.name = "NEW"
    // other.test // NEW
    other.test = "HI"
    // sample.name // HI
}

/// ============ 键路径层级 ===========
/*
 键路径有五种不同的类型，每种类型都在前⼀种上添加了更加精确的描述及功能：

 → AnyKeyPath 和 (Any) -> Any? 类型的函数相似

 → PartialKeyPath<Source> 和 (Source) -> Any? 函数相似

 → KeyPath<Source, Target> 和 (Source) -> Target 函数相似

 → WritableKeyPath<Source, Target> 和 (Source) -> Target 与 (inout Source, Target) -> () 这⼀对函数相似

 → ReferenceWritableKeyPath<Source, Target> 和 (Source) -> Target 与

 (Source, Target) -> () 这⼀对函数相似。第⼆个函数可以⽤ Target 来更新 Source 的值， 且要求 Source 是⼀个【引⽤类型】（所以即使Source是let定义 也可以修改）。对 WritableKeyPath 和 ReferenceWritableKeyPath 进⾏区分是必要的，前⼀个类型的 setter 要求它的参数是 inout 的。
 */

/// 键路径不同于函数，它们是满⾜ Hashable 的，⽽且在将来它们很有可能还 会满⾜ Codable。这也是为什么我们强调 AnyKeyPath 和 (Any) -> Any 只是相似的原因。虽然 我们能够将⼀个键路径转换为对应的函数，但是我们⽆法做相反的操作。

/// 后续特性：⼀个可能的特性是通过 Codable 进⾏序列化。这将允许我们把键路径存储到磁盘上，或者是通过⽹络进⾏传递。⼀旦 我们可以访问到键路径的结构，我们就可以进⾏内省 (introspection，或者说是 “运⾏时的类型 检查”)。⽐如，我们可以⽤键路径的结构来构建带有类型的数据库查询语句。如果类型能够⾃ 动提供它们的属性的键路径数组的话，就可以作为运⾏时反射 API 的基础了。


/// ============ 自动闭包 ===========

/// aa && bb
/// ⼀旦左边的结果是 false 的话，整个表达式就不可能是 true 了。这种⾏为⼜ 被叫做【短路求值】
/// 第一个语句失败 就不会去执行 第二个语句（减少昂贵的计算）

// swift的实现
func and0(_ l: Bool, _ r: () -> Bool) -> Bool {
    guard l else { return false }
    return r()
}
/*
 if and(!evens.isEmpty, { evens[0] > 10 }) { // 执⾏操作

 }
 */

/// 尾随闭包优化: 尾随闭包的方法 会被 延迟执行
// 过度使⽤⾃动闭包可能会让你的代码难以理解。使⽤时的上下⽂和函数名应该清晰地 指出实际求值会被"推迟"。
func and(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
    guard l else { return false }
    return r()
}

/*
 // 减少 {}
 if and(!evens.isEmpty, evens[0] > 10) { // 执⾏操作

 }
 */

/// 注意默认⾮逃逸的规则只对函数参数，以及那些直接参数位置 (immediate parameter position) 的函数类型有效。
/// 也就是说，如果⼀个存储属性的类型是函数的话，那么它将会是逃 逸的 (这很正常)。
/// 出乎意料的是，对于那些使⽤闭包作为参数的函数，如果闭包被封装到像是 "多元组"或者"可选值"等类型的话，这个闭包参数也是"逃逸的"。
/// 因为在这种情况下闭包不是 直接参数，它将⾃动变为逃逸闭包。
/// 这样的结果是，你不能写出⼀个函数，使它接受的函数参数同时 满⾜可选值和⾮逃逸。
/// 很多情况下，你可以通过为闭包提供⼀个默认值来避免可选值。如果这 样做⾏不通的话，可以通过重载函数，提供⼀个包含可选值 (逃逸) 的函数，以及⼀个不可选， 不逃逸的函数来绕过这个限制：

// 重载
// 当传入的闭包为nil时，调用第一个方法，此时是 逃逸闭包
// 当传入的闭包不为空时，调用第二个方法，此时是 非逃逸闭包
func transform(_ input: Int, with f: ((Int) -> Int)?) -> Int {
    print("使⽤可选值重载")
    guard let f = f else { return input }
    return f(input)
}

func transform(_ input: Int, with f: (Int) -> Int) -> Int {
    print("使⽤⾮可选值重载")
    return f(input)
}

/*
 transform(10, with: nil) // 使⽤可选值重载
 transform(10) { $0 * $0 } // 使⽤⾮可选值重载
 */

/// ============ withoutActuallyEscaping ===========

extension Array {
    // 因为是lazy方法，所以predicate被定义为逃逸，编译器提示添加 @escaping
    func all(matching predicate: @escaping (Element) -> Bool) -> Bool { // 错误：'predicate' 参数隐式⾮逃逸
        return self.lazy.filter({ !predicate($0) }).isEmpty
    }
}

/// 但是在这种情况下，我们确实知道 闭包不会逃逸，因为延迟集合的⽣命周期是绑定在函数上的
/// withoutActuallyEscaping: 把⼀个⾮逃逸闭包传递给⼀个期待逃 逸闭包作为参数的函数 (最终 不逃逸)
extension Array {
    func allNonEscaping(matching predicate: (Element) -> Bool) -> Bool {
        return withoutActuallyEscaping(predicate) { escapablePredicate in
            self.lazy.filter { !escapablePredicate($0) }.isEmpty }
    }
}

/// 注意，使⽤ withoutActuallyEscaping 后，你就进⼊了 Swift 中不安全的领域。让闭包的复制 从 withoutActuallyEscaping 调⽤的结果中逃逸的话，会造成不确定的⾏为。


