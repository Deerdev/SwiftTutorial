//
//  CollectionAdvance.swift
//  SwiftTutorial
//
//  Created by daoquan on 2017/12/20.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

// MARK: - 🔴array
/// 数组和可选值
func arrayAdvance() {
    let array = [0, 1, 2, 3, 4, 5]
    
    // 1.1 指定元素的位置
    if let index = array.index(where: {
        if $0 == 2 {
            return true
        }
        return false
    }) {
        print(index)    // 2
    }
    
    // 1.2 操作(变换)元素
    let operatedArrray = array.map {
        return $0 * 2
    }
    print(operatedArrray)   // [0, 2, 4, 6, 8, 10]
    
    // 1.3 筛选元素
    let filterArray = array.filter {
        if $0 > 3 {
            return true
        }
        return false
    }
    print(filterArray)  // [4, 5]
    
    // 求和
    let reduceArray0 = array.reduce(0) { $0 + $1 }  // 15
    let reduceArray1 = array.reduce(0, +)   // 15
    // 转字符串
    let reduceArray2 = array.reduce("") { $0 + "\($1) " }   // "0 1 2 3 4 5 "
    print(reduceArray0, reduceArray1, reduceArray2)
}

// MARK: - 🔴dict
/// 字典
func dictAdvance() {
    let dict = ["1": "one", "2": "two"]
    
    // 对value进行转换
    let dict1 = dict.mapValue {
        "\($0)_\($0)"
    }
    print(dict1)    // ["2": "two_two", "1": "one_one"]
    
    // dict2 符合 S.Iterator.Element == (key: Key, value: Value)
    let dict2 = dict.map { (key, value) -> (String, String) in
        return (key, value.uppercased())
    }
    print(dict2)    // [("2", "TWO"), ("1", "ONE")]
}

/// Dictionary常用的Extention
extension Dictionary {
    // merge
    // 把两个相同类型的字典合并，key相同时替换value
    // S必须遵从Sequence protocol: S.Iterator.Element == (key: Key, value: Value)
    mutating func merge<S:Sequence>(_ sequence: S)
        // 类型必须是字典定义的Key和Value
        where S.Iterator.Element == (key: Key, value: Value) {
            
            sequence.forEach { self[$0] = $1 }
    }
    
    // 用一个tuple数组初始化Dictionary
    // 符合 S.Iterator.Element == (key: Key, value: Value)的序列 都可以用来初始化Dict
    init<S:Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) {
            
            self = [:]
            self.merge(sequence)
    }
    
    // 改变value的形式
    func mapValue<T>(_ transform: (Value) -> T) -> [Key: T] {
        // map得到了一个Array<(String, RecordType)>类型的Array，而后，由于Array也遵从了Sequence protocol，因此，我们就能直接使用这个Array来定义新的Dictionary了
        return Dictionary<Key, T>(map { (k, v) in
            return (k, transform(v))
        })
    }
}

/// hashable
/*
 具备hashable需要实现两个协议：Equatable Hashable
 具备Hashable即可用来作为Dictionary的key
 */
struct PersonStruct {
    var name: String
    var zipCode: Int
    var birthday: Date
}

extension PersonStruct: Equatable {
    static func ==(lhs: PersonStruct, rhs: PersonStruct) -> Bool {
        return lhs.name == rhs.name && lhs.zipCode == rhs.zipCode && lhs.birthday == rhs.birthday
    }
}

extension PersonStruct: Hashable {
    public var hashValue: Int {
        // 异或计算 成员(已具备Hashable)的hash value
        // 异或的左右对称 a ^ b == b ^ a，也会造成不必要的碰撞，【添加一个位旋转】(https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html)
        return name.hashValue ^ zipCode.hashValue ^ birthday.hashValue
    }
}

/*
 当你使用不具有【值语义】的类型 (比如可变的对象) 作为字典的键时，需要特别小心。
 如果你在将一个对象用作字典键后，改变了它的内容，它的哈希值和/或相等特性往往也会发生改变。
 这时候你将无法再在字典中找到它。这时字典会在错误的位置存储对象，这将导致字典内部存储的错误。
 对于值类型来说，因为字典中的键不会和复制的值共用存储，因此它也不会被从外部改变，所以不存在这个的问题
 */


// MARK: - 🔴set
/// 集合Set
func setAdvance() {
    /// 索引集合 IndexSet: 由正整数组成的集合
    // IndexSet里其实只存储了选择的首位和末位两个整数值
    var indices = IndexSet()
    indices.insert(integersIn: 1..<5)   // CountableRange(1..<5)
    indices.insert(integersIn: 11..<15) // CountableRange(1..<5), CountableRange(11..<15)
    let evenIndices = indices.filter { $0 % 2 == 0 } // [2, 4, 12, 14]
    print(evenIndices)
    
    [1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique() // [1, 2, 3, 12, 4, 5, 6]
    
    
    /// 字符集合 CharacterSet: 高效的存储 Unicode 字符的集合(实际不是一个集合类型)
}

extension Sequence where Iterator.Element: Hashable {
    /// 寻找集合中 唯一的元素，并且维持原来的顺序
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return self.filter({
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        })
    }
}


// MARK: - 🔴range
/// Range
func rangeAdvance() {
    // 5..<5 半开 可以表达 空区间
    // 0...Int.max 闭合区间 可以包含 元素类型值的 最大值
    
    /// Range的类型
    /*
     半开范围             闭合范围
     —————————————————————————————————————————————————————————————————
     元素满足 Comparable    Range               ClosedRange
     元素满足 Strideable    CountableRange      CountableClosedRange
     (以整数为步长)          (可数范围)
     
     -----------------------------------------------------------------
     ** `Strideable`以整数为步长，可以创建序列，而`Comparable`不可创建序列
     
     */
    let singleDigitNumbers0 = 0..<10 // CountableRange(0..<10)
    let singleDigitNumbers1 = 0...10 // CountableClosedRange(0...10)
    let lowercaseLetters0 = Character("a")...Character("z")  // ClosedRange("a"..."z")
    let lowercaseLetters1 = Character("a")..<Character("z")  // Range("a"..<"z")
    print(singleDigitNumbers0, singleDigitNumbers1, lowercaseLetters0, lowercaseLetters1)
    
    /*
     ❗️错误： 'ClosedRange<Character>' 类型不遵守 'Sequence' 协议
     
     for char in lowercaseLetters0 {}
     */

    // CountableRange可数范围，集合类型
    _ = singleDigitNumbers0.map { $0 * $0 } // [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
}


