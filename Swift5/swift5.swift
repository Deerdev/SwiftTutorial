//
// Created by Deer on 2019/9/1.
// Copyright (c) 2019 deerdev. All rights reserved.
//

import Foundation

/// @dynamicCallable 语法糖
@dynamicCallable struct ToyCallable {
    func dynamicallyCall(withArguments: [Int]) {}
    func dynamicallyCall(withKeywordArguments: KeyValuePairs<String, Int>) {}
}

func test1() {
    let x = ToyCallable()

    x(1, 2, 3)
    // 上面的代码实际上是一个语法糖，如果不用语法糖的话，代码会像这样子写  `x.dynamicallyCall(withArguments: [1, 2, 3])`

    x(label: 1, 2)
    // 上面的代码实际上是一个语法糖，如果不用语法糖的话，代码会像这样子写   `x.dynamicallyCall(withKeywordArguments: ["label": 1, "": 2])`
}

/// keypath 增加 \.self, 可读可写（WritableKeyPath）
func test2() {
    let id = \Int.self
    var x = 2
    print(x[keyPath: id]) // Prints "2"
    x[keyPath: id] = 3
    print(x[keyPath: id]) // Prints "3"
}
