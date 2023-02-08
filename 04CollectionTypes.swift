//
//  04CollectionTypes.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/3/6.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// 集合：Arrays Sets Dictionaries

// MARK: - array

// MARK: - 数组
func arraryInfo() -> Void {
    
    /// 数组定义Array<Element> || [Element]
    // *** 值类型，不是引用 ***
    
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
    // [int]
    var threeInt2 = [Int](repeating:22, count:3)
    print(threeDoubles)
    print(threeInt)
    
    /// ** slice初始化 **
    // +---------+---+
    // | length  | 5 |
    // +---------+---+
    // | storage ptr |
    // +---------+---+
    //           |
    //           v
    //           +---+---+---+---+---+---------------------+
    //           | 1 | 2 | 3 | 4 | 5 |  reserved capacity  |
    //           +---+---+---+---+---+---------------------+
    //           ^
    //           |
    // +---------+---+
    // | storage ptr |
    // +---------+---+
    // | beg idx | 0 |
    // +---------+---+
    // | end idx | 3 |  ArraySlice for [0...2]
    // +---------+---+
    // threeInt[0...2] 返回的不是数组，是ArraySlice，理解为Array某一段内容的view，是数组范围的一个引用
    var twoInt = Array(threeInt[0...2])
    
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
    if stringList.isEmpty {}
    
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
    // 在开始插入
    stringList.insert("start", at: stringList.startIndex)
    // 在结尾插入
    stringList.insert("end", at: stringList.endIndex)
    
    print(stringList) // ["horse", "egg", "dog", "cat", "cheese", "Butter"]
    // 其他插入方法
//    stringList.insert(contentsOf: Collection, at: Int)
    
    /// 删除
    stringList.remove(at: 0)
    print(stringList) // ["egg", "dog", "cat", "cheese", "Butter"]
    // 删除最后一项（不能是 空数组, 会crsh）
    stringList.removeLast()
    // 删除最后一项（空数组不会crsh）
    stringList.popLast()
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
    for item in stringList {}
    
    // 遍历下标和值 enumrated
    for (index, value) in stringList.enumerated() {
        print("Item \(String(index+1)): \(value)")
    }
    
//    stringList.forEach{ str in
//        print(str)
//    }
    stringList.forEach{
        print($0)
    }
    
    /// swift数组的正确使用(减少下标的使用)
    let a = [0, 1, 2, 3, 4, 5]
    // 查找数组中值为1的元素的位置，返回Optional<Int>
    _ = a.firstIndex { $0 == 1 }
    // 过滤数组元素(显示出数组中的 偶数)
    _ = a.filter { $0 % 2 == 0 }

    // first last都是option类型(可能是空数组)
    _ = a.first // 0    = isEmpty ? nil : self[0]
    _ = a.last  // 5
    _ = type(of: a.first) // Optional<Int>.Type
    
    /// 获取“满足条件”的元素的分界点
    /// partition(by:)则会根据指定的条件返回一个分界点位置。这个分界点分开的两部分中，前半部分的元素都不满足指定条件；后半部分都满足指定条件。
    var fibonacci = [5, 3, 2, 1, 1, 0]
    let pivot = fibonacci.partition(by: { $0 < 1 })     // 分解点：index: 5(不包含)
//    fibonacci[0 ..< pivot]      // [5, 3, 2, 1, 1]
//    fibonacci[pivot ..< fibonacci.endIndex]     // [0]
    
    /// 把数组的所有内容，“合并”成某种形式的值
    // 指定合并的初始值“0”，合并的规则“+”（参数+，是{ $0 + $1 }的缩写）
    fibonacci.reduce(0, +) // 12
}

// MARK: - set
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
    //    var favoriteGenres:lett<String> = ["Rock", "Classical", "Hip hop"]
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

// MARK: - dict
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
    
    /// 移除键值，给值赋值nil
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
//    airPorts.sorted(by: ((key: String, value: String), (key: String, value: String)) -> Bool)
    
}

/// 只有数组的下标返回的是对应下标的值，其他集合类型返回的是对应下标的 值 的拷贝















