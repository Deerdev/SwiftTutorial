//
//  22Protocols.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/5.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 1.协议定义 Protocol Syntax

protocol FirstProtocol {
    // protocol definition goes here
}
protocol AnotherProtocol {
    // protocol definition goes here
}

// 先是父类，再是协议
class SomeClass0: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}

/// 2.属性要求 Property Requirements
// 协议只定义 属性名 、 属性类型、 可读可写； 不管是 存储型 还是 计算型
// 总是使用 var 来声明属性
protocol SomeProtocol {
    // 可读可写
    var mustBeSettable: Int { get set }
    // 只读
    var doesNotNeedToBeSettable: Int { get }
}

protocol AnotherProtocol2 {
    // 类属性 static
    static var someTypeProperty: Int { get set }
}

// ***例如***
protocol FullyNamed {
    var fullName: String { get }
}
struct PersonFully: FullyNamed {
    // 实现为存储属性
    var fullName: String
}
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    // 实现为计算属性
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
// *** ***

/// 3.方法要求 Method Requirements
// 协议中的方法 不需要大括号和实现体
// 方法参数不提供默认值
// 实例方法  类方法

protocol SomeProtocol1 {
    // 类方法
    static func someTypeMethod()
}

protocol RandomNumberGenerator {
    // 实例方法
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    // 实现协议定义的 实例方法
    func random() -> Double {
        // lastRandom = ((lastRandom * a + c) % m)
        // 浮点型的 取余，不能使用 %
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

/// 4.Mutating 方法要求 Mutating Method Requirements
// 需要在方法中 修改 方法所属的实例
// 实现 协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字
protocol Togglable {
    // mutating 可变实例方法
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case Off, On
    // 来回切换self
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}


/// 5.构造器要求 Initializer Requirements
// 协议可以要求遵循协议的类型实现 指定的构造器
protocol SomeProtocol2 {
    init(someParameter: Int)
}

class SomeClass2: SomeProtocol2 {
    // *** 类在实现协议构造函数时，添加【required】关键字，保证子类也要实现该构造器，遵循协议 ***
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
    
    // 如果类已经被标记为【final】，那么 不需要 在协议构造器的实现中使用 required 修饰符
}

// *** 如果 子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，同时标注【required】和【override】修饰符***
protocol SomeProtocol3 {
    init()
}

class SomeSuperClass3 {
    init() {
        // initializer implementation goes here
    }
}
class SomeSubClass3: SomeSuperClass3, SomeProtocol3 {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

// 可失败构造器 要求 Failable Initializer Requirements
// 协议定义 可失败构造器 <---> 类实现方式（init?）或（init）
// 协议定义 非失败构造器 <---> 类实现方式（init）或（init！）


/// 6.协议作为类型 Protocols as Types

/* 
 * 协议作为类型：
 * 1 作为函数、方法或构造器中的 参数类型 或 返回值类型
 * 2 作为常量、变量或属性的类型
 * 3 作为数组、字典或其他容器中的元素类型
*/

// 类似虚基类，可以传递所有实现虚基类方法的 子类
class Dice {
    let sides: Int
    // 属性类型
    let generator: RandomNumberGenerator
    // 参数类型
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
    // generator 属性的类型为 RandomNumberGenerator，因此任何遵循了 RandomNumberGenerator 协议的类型的 实例 都可以赋值给 generator
}

/// 7.委托（代理）模式 Delegation
// 委托 是一种设计模式，它允许类或结构体将一些需要它们负责的功能 委托给其他类型的实例
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

// delegate
protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}


class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    
    // 可选类型的 代理属性
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        
        // 可选链式 调用委托方法
        delegate?.gameDidStart(self)
        
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            
            // 可选链式 调用委托方法
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        
        // 可选链式 调用委托方法
        delegate?.gameDidEnd(self)
    }
}

// 实现DiceGameDelegate 代理
class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    // 代理方法，实现DiceGame的类都可以作为 参数
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        // 判断参数类型
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    // 代理方法
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    // 代理方法
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

func delegateProtocolTest() {
    let tracker = DiceGameTracker()
    let game = SnakesAndLadders()
    game.delegate = tracker
    game.play()
}

/// 8.通过扩展添加协议一致性
// 通过扩展，让已有类 遵循协议，该类型的所有实例 也会随之获得协议中定义的各项功能
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    // 在扩展体内，实现协议要求的 方法
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

/// 9.通过扩展遵循协议 “Adding Protocol Conformance with an Extension“
// 某个类型 已经实现了协议的所有要求，直接通过扩展声明一下 协议 即可
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}


/// 10.协议类型的集合 “Collections of Protocol Types”
func protocolArray() {
    let game = SnakesAndLadders()
    let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
    let simonTheHamster = Hamster(name: "Simon")
    
    let things: [TextRepresentable] = [game, d12, simonTheHamster]
    for thing in things {
        // 只能调用协议（类型）定义的方法
        print(thing.textualDescription)
    }
}

/// 11.协议的继承 Protocol Inheritance
// 协议可以 继承 一个或多个 协议
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // protocol definition goes here
}


protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
extension SnakesAndLadders: PrettyTextRepresentable {
    
    // 实现PrettyTextRepresentable要求的 属性
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}


/// 12.类 类型 专属协议 Class-Only Protocols
// 在协议的继承列表中，通过添加【class】关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议。
// class 关键字必须第一个出现在协议的继承列表中

protocol SomeClassOnlyProtocol: class, InheritingProtocol {
    // class-only protocol definition goes here
}

// *** 当协议定义的要求 需要遵循协议的类型 "必须是 引用语义" 而非值语义时，应该采用 类 类型专属协议 ***

/// 13.协议合成 Protocol Composition
// 将多个协议采用 SomeProtocol & AnotherProtocol 这样的格式进行组合，称为 协议合成（protocol composition）

protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person5: Named, Aged {
    var name: String
    var age: Int
}
// 参数要同时遵循 Named协议 和 Aged协议，这里可以传递 Person5 实例
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

//let birthdayPerson = Person(name: "Malcolm", age: 21)
//wishHappyBirthday(to: birthdayPerson)

/// 14.检查协议的一致性 “Checking for Protocol Conformance”
/**
 * is  用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
 * as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
 * as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
**/
protocol HasArea {
    var area: Double { get }
}
class Circle2: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}

class Animal2 {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

func checkProtocol() {
    let objects: [AnyObject] = [
        Circle2(radius: 2.0),
        Animal2(legs: 4)
    ]
    
    for object in objects {
        // 判断 是否都遵循 HasArea协议
        if let objectWithArea = object as? HasArea {
            print("Area is \(objectWithArea.area)")
        } else {
            print("Something that doesn't have an area")
        }
    }
    // Area is 12.5663708
    // Something that doesn't have an area
}

/// 15.可选的协议要求 Optional Protocol Requirements
// 遵循协议的类型，选择实现 协议要求的属性或方法
// 兼容ObjectC使用，添加关键字【@objc】【optional】
@objc protocol CounterDataSource {
    // 整个方法都是可选的((Int) -> Int)?，不是 返回值可选
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        // 可选函数的调用，函数名后 加 ?
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
            // 可选属性的调用
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

/// 16.协议扩展 Protocol Extensions
// 通过扩展 为协议添加 方法 属性，并实现方法的 默认实现（Providing Default Implementations）
// 遵循该协议的类型，自动拥有这些方法，不用重新实现
extension RandomNumberGenerator {
    // 定义新方法，并实现
    // 遵循该协议的类  可以直接使用
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

// *** 如果遵循协议的类 已经提供了 自定义实现，那么自定义实现会 覆盖协议的默认实现 ***

/// 17.为协议扩展 添加限定条件 “Adding Constraints to Protocol Extensions”
// 为扩展添加限定条件，只有“遵循协议的类型 满足 这些限制条件时”，才能获得协议扩展提供的默认实现。
// 这些限制条件写在协议名之后，使用【where】子句来描述

// 例：扩展 Collection协议
// 限定：“只适用于集合中的元素遵循了 TextRepresentable 协议”
extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

func collertionProtocol() {
    let murrayTheHamster = Hamster(name: "Murray")
    let morganTheHamster = Hamster(name: "Morgan")
    let mauriceTheHamster = Hamster(name: "Maurice")
    let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
    
    // 数组中的成员都符合 扩展协议的限定条件
    print(hamsters.textualDescription)
    // Prints "[A hamster named Murray, A hamster named Morgan, A hamster named Maurice]"
}

// *** 如果一个协议 写了多个 协议扩展+限定条件（提供了相同方法的默认实现），且遵循该协议的类型 都符合这些限定条件，
// *** 那么该类型，将会使用“限制条件最多”的那个协议扩展提供的 默认实现

// —————————————————————————————————————————————————————————————————

/// <-------------------------- protocols do not conform to themselves --------------------------->
// https://stackoverflow.com/questions/40783044/associatedtype-swift-3
protocol Protocol_1 {
    associatedtype T
}

protocol Protocol_A {}
struct SomeStruct_2: Protocol_A {}

struct SomeStruct_1: Protocol_1 {
    typealias T = Protocol_A
}

// 通过 == 判断类型匹配，而不是conform(:)
//func testFunction<P: Protocol_1>(t: P) where P.T : Protocol_A {}
func testFunction<P: Protocol_1>(t: P) where P.T == Protocol_A {}

func testFunction() {
    let struct1 = SomeStruct_1()
    testFunction(t: struct1) // *Generic parameter 'P' could not be inferred*
}

