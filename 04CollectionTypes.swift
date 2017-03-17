//
//  04CollectionTypes.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/3/6.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 集合：Arrays Sets Dictionaries

func arraryInfo() -> Void {
    
    /// 数组定义Array<Element> || [Element]
    // 空数组
    var someInts = [Int]()
    var someInts2: [Int] = []
    
    print("someInt is of type [Int] with \(someInts.count) items.")
    
    // 添加元素，再次清空
    someInts.append(3)
    print("someInt is of type [Int] with \(someInts.count) items.")
    // 有类型判断，直接赋值[]
    someInts = []
    print("someInt is of type [Int] with \(someInts.count) items.")
    
    
    /// 创建默认值数组
    // Repeated<T>
    var threeDoubles = repeatElement(0.0, count: 3)
    // Array<Int>
    var threeInt = Array(repeating:22, count:3)
    print(threeDoubles)
    print(threeInt)
    
    // (相同类型)数组相加
    var anotherThreeInt = Array(repeating: 33, count: 3)
    var sixInt = threeInt + anotherThreeInt
    print(sixInt) // [22, 22, 22, 33, 33, 33]
    
    /// 字面量初始化
    // var stringList: [String] = ["egg", "Milk"]
    var stringList = ["egg", "Milk"] //推断类型
    
    /// 数组基本操作
    // 计数
    print("stringList contains \(stringList.count) items.")
    // 是否为空
    if stringList.isEmpty {
    }
    
    // 添加元素
    stringList.append("water")
    // 加法赋值
    stringList += ["cheese", "Butter"]
    
    // 下标获取
    var firstItem = stringList[0]
    
    // 部分替换
    print(stringList) // ["egg", "Milk", "water", "cheese", "Butter"]
    stringList[1...2] = ["dog", "cat"]
    print(stringList) // ["egg", "dog", "cat", "cheese", "Butter"]
    
    /// 插入
    stringList.insert("horse", at: 0)
    print(stringList) // ["horse", "egg", "dog", "cat", "cheese", "Butter"]
    // 其他插入方法
//    stringList.insert(contentsOf: Collection, at: Int)
    
    /// 删除
    stringList.remove(at: 0)
    print(stringList) // ["egg", "dog", "cat", "cheese", "Butter"]
    // 删除最后一项
    stringList.removeLast()
    print(stringList) // ["egg", "dog", "cat", "cheese"]
    // 删除最后两项
    stringList.removeLast(2)
    print(stringList) // ["egg", "dog"]
//    stringList.removeAll()
//    stringList.removeFirst()
//    stringList.removeSubrange(bounds: Range<Int>)
    
    /// 是否包含某个关键值
    if stringList.contains("egg") {
        print("stringList contains egg")
    }
    
    /// 遍历
    for item in stringList {
    }
    // 遍历下标和值
    for (index, value) in stringList.enumerated() {
        print("Item \(String(index+1)): \(value)")
    }
}

func setInfo() -> Void {
    /// 集合的值具有唯一性
    // a == b --> a.hashValue == b.hashValue
    // 判断相等：可哈希化 --> 实现Hashable协议、Equatable协议
    
    
    /// 基本定义
    // Set<Element>
    var letters = Set<Character>()
    print("letters is of type Set<Character> with \(letters.count) items.")
    letters.insert("a")
    letters = [] // 类型推断
    // 字面量初始化
//    var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
    var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"] // 简化表达，但必须显示声明"Set"
    
    /// Set操作
    // .count
    // .isEmpty
    // .insert(_:)
    // .remove(_:)    ---> 返回被删除的元素，或者nil（所以返回可选类型）
    // .removeall()
    // .contains(_:)
    
    /// 遍历
    for genre in favoriteGenres {
        print("\(genre)")
    }
    
    /// 有序排列(<)
    for genre in favoriteGenres.sorted() {
        print("\(genre)")
    }
    
    /// 集合的操作（子集，交集，并集）
    let a: Set = [1, 3, 5, 7, 9]
    let b: Set = [0, 1, 2, 4, 6, 8]
    // 交集
    var c = a.intersection(b)
    print(c) // [1]
    // 并集
    c = a.union(b)
    print(c) // [0, 2, 9, 4, 5, 7, 6, 3, 1, 8]
    // a中不含b的部分
    c = a.subtracting(b)
    print(c) // [5, 7, 3, 9]
    // 交集之外的元素
    c = a.symmetricDifference(b)
    print(c) // [2, 9, 4, 5, 7, 6, 3, 0, 8]
    
    /// 集合包含关系
    let a1: Set = [1, 3, 5, 6, 7, 8]
    let a2: Set = [1, 3, 5, 6, 7, 8]
    let a3: Set = [1, 3, 5]
    let a4: Set = [2, 4]
    
    print("a1是a2的子集 a1 ⊆ a2：\(a1.isSubset(of: a2))")
    print("a1是a2的父集 a1 ⊇ a2：\(a1.isSuperset(of: a2))")
    print("a3 ⊂ a1 (不相等):\(a3.isStrictSubset(of: a1))")
    print("a1 ⊃ a3 (不相等):\(a1.isStrictSuperset(of: a3))")
    print("a1 ≠ a4 (两个集合不含相同值，没有交集):\(a1.isDisjoint(with: a4))")
    
}

func dictInfo() -> Void {
    /// Dictionary<Key, Value>
    /// Key必须遵循Hashable协议
    // 简化 [Key: Value]
    
    /// 创建字典
    // 空字典[Int: String]
    var namesOfIntegers = [Int: String]()
    namesOfIntegers[16] = "sixteen"
    namesOfIntegers = [:] // 再置空
    
    // 字面量初始化
//    var airPorts: [String: String] = ["YYZ": "Pearson", "DUB": "Dublin"]
    var airPorts = ["YYZ": "Pearson", "DUB": "Dublin"]
    
    /// 访问/修改字典
    // .count
    // .isEmpty
    // 使用下标添加新数据
    airPorts["LHR"] = "London"
    // 用下标，修改值
    airPorts["LHR"] = "London Heathrow"
    
    // 返回optional，该键值存在，返回旧值；如果该键值不存在，新建键值，返回nil
    airPorts.updateValue("Jim", forKey: "LHR")
    print(airPorts)
    
    // 移除键值，给值赋值nil
    airPorts["LHR"] = nil
    print(airPorts)
    // 移除键值,返回optional，存在，返回旧值；不存在，返回nil
    airPorts.removeValue(forKey: "DUB")
    print(airPorts)
    
    /// 字典遍历
    for (key, value) in airPorts {
        print("\(key): \(value)")
    }
    
    // key遍历
    for key in airPorts.keys {
        print("Airport code: \(key)")
    }
    // value遍历
    for value in airPorts.values {
        print("Airport name: \(value)")
    }
    
    /// 取出Key和Value作为数组(转为Array类型)
    let keys = [String](airPorts.keys)
    let values = [String](airPorts.values)
    
    /// 排序(针对key或value排序)
//    airPorts.sorted(by: <#T##((key: String, value: String), (key: String, value: String)) -> Bool#>)
    
}

















