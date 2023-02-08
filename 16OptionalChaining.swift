//
//  16OptionalChaining.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/2.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation


/// =====swift4=======
/// T! 类型也是T?类型，只不过系统会自动unwrap
// T! 已经不是一个类型
// 限制了T!使用的场景 var e: [Int!] = [] // error: Using '!' is not allowed here; perhaps '?' was intended?

func implicitlyUnwrappedOptional() {
    var a: Int?
    var b: Int!
//    其中，a的类型是Optional<Int>，而b的类型则是ImplicitlyUnwrappedOptional<Int>。而在Swift4.2中，a和b的类型，都变成了Optional<Int>，只不过，对b来说，编译器会给它做一个标记，以便“在必要的时候”，自动unwrap它包含的值。也就是说，在4.2版本之后，无论是!还是?，代码中都只有一个optional类型，就是Optional<T>

    // sumFn接受两个Optional<Int>参数，并返回一个Optional<Int>，只不过允许编译器自动解出optional的值而已
    // (Int?, Int?) -> Int?
    func sumFn(_ m: Int!, _ n: Int!) -> Int! {
        return m + n
    }

    var x: Int! // 实际类型是Int?
    let y = x // Int?

    func id<T>(_ value: T) -> T { return value }
    type(of: id(x)) // Int?

    func forcedResult() -> Int! { return x }    // 尽管forcedResult的定义里返回了Int!，但是Swift推导出来的类型是() -> Int?
    type(of: forcedResult) // () -> Optional<Int>

    func apply<T>(_ fn: () -> T) -> T { return fn() }
    // Error: Value of optional type 'Int?' not unwrapped
//    let n: Int = apply(forcedResult)


    /// AnyObject 类型
    class A: NSObject {}

    class C {
        @objc var n: A! = A()
    }

    func getProperty(object: AnyObject) {
//        type(of: object.n)

        // 在4.2之前的Swift版本里，访问AnyObject的属性，得到的都是T!。例如，object.n得到的类型就是A!!
        // 4.2之后，n 实际就unwrap了一次，所以n的类型还是 A?
//        if let n = object.n {
//            type(of: n)
//        }

        // 强制指定 n 的类型为 A，unwrap 两次
//        if let n: A = object.n {
//            type(of: n)
//        }
    }

    getProperty(object: C())
}




/// Defining Model Classes for Optional Chaining

class Person {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

/// 通过可选链访问属性 “Accessing Properties Through Optional Chaining”

func accessingPropertyThroughChain() {
    let john = Person()
    if let roomCount = john.residence?.numberOfRooms {
        print("John's residence has \(roomCount) room(s).")
    } else {
        print("Unable to retrieve the number of rooms.")
    }
    // Prints "Unable to retrieve the number of rooms."
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    // 通过可选链 给 属性赋值
    // *** 可选链式调用失败时，等号右侧的代码不会被执行 ***
    john.residence?.address = someAddress

    // 调用是否成功的判断
    if (john.residence?.address = someAddress) != nil {
        print("It was possible to set the address.")
    } else {
        print("It was not possible to set the address.")
    }
}

/// 通过可选链调用方法 “Calling Methods Through Optional Chaining”
// 通过可选链式调用来调用方法，并判断是否调用成功，即使这个方法没有返回值。
func callingMethodThroughChain() {
    
    let john = Person()
    if let roomCount = john.residence?.numberOfRooms {
        print("John's residence has \(roomCount) room(s).")
    } else {
        print("Unable to retrieve the number of rooms.")
    }
    // Prints "Unable to retrieve the number of rooms."
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    
    // printNumberOfRooms()方法 会返回 【Void?】-->成功返回空元组()，失败返回nil
    // 函数是否调用成功的 判断
    if john.residence?.printNumberOfRooms() != nil {
        print("It was possible to print the number of rooms.")
    } else {
        print("It was not possible to print the number of rooms.")
    }
    // 打印 “It was not possible to print the number of rooms.”
}

/// 通过可选链访问下标 “Accessing Subscripts Through Optional Chaining”
// 当你通过可选链访问一个可选项的下标时，你需要把问号放在下标括号的前边 xxx?[]
func accessingSubThrouChain() {
    let john = Person()
    
    // 访问下标
    if let firstRoomName = john.residence?[0].name {
        print("The first room name is \(firstRoomName).")
    } else {
        print("Unable to retrieve the first room name.")
    }
    // Prints "Unable to retrieve the first room name."
    
    john.residence?[0] = Room(name: "Bathroom")
    
    
    // 对字典的可选类型下标 访问
    var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
    testScores["Dave"]?[0] = 91
    testScores["Bev"]?[0] += 1
    testScores["Brian"]?[0] = 72 // 失败
    // the "Dave" array is now [91, 82, 84] and the "Bev" array is now [80, 94, 81]
}



/// 连接多层可选链式调用 “Linking Multiple Levels of Chaining”
// 多层可选链不会给返回的值添加多层的可选性
// * 如果你访问的值不是可选项，它会因为可选链而变成可选项；
// * 如果你访问的值已经是可选的，它不会因为可选链而变得更加可选。
// (例如) 通过可选链式调用访问Int?值，依旧会返回Int?值，并不会返回Int??。
func multiLinkChain() {
    let john = Person()
    let johnsAddress = Address()
    johnsAddress.buildingName = "The Larches"
    johnsAddress.street = "Laurel Street"
    john.residence?.address = johnsAddress
    
    if let johnsStreet = john.residence?.address?.street {
        print("John's street name is \(johnsStreet).")
    } else {
        print("Unable to retrieve the address.")
    }
    // Prints "John's street name is Laurel Street."
}

/// 在方法的可选返回值上进行可选链式调用 “Chaining on Methods with Optional Return Values”
func optReturnfromMethodChain() {
    let john = Person()
    let johnsAddress = Address()
    johnsAddress.buildingName = "The Larches"
    johnsAddress.street = "Laurel Street"
    john.residence?.address = johnsAddress
    
    if let johnsStreet = john.residence?.address?.street {
        print("John's street name is \(johnsStreet).")
    } else {
        print("Unable to retrieve the address.")
    }
    // Prints "John's street name is Laurel Street."
    
    if let beginsWithThe =
        john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
        if beginsWithThe {
            print("John's building identifier begins with \"The\".")
        } else {
            print("John's building identifier does not begin with \"The\".")
        }
    }
    // Prints "John's building identifier begins with "The"."
}








