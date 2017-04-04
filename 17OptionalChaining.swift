//
//  17OptionalChaining.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/2.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

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








