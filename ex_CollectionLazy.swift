//
//  ex_CollectionLazy.swift
//  SwiftTutorial
//
//  Created by deerdev on 2018/8/9.
//  Copyright © 2018年 deerdev. All rights reserved.
//

import Foundation

func whatLazyFor() {
    func increment(x: Int) -> Int {
        print("Computing next value of \(x)")
        return x+1
    }
    
    /// 没有lazy时，在打印incArray[0], incArray[4]之前，array的“所有元素”都执行了increment操作
    let array = Array(0..<1000)
    let incArray = array.map(increment)
    print("Result:")
    print(incArray[0], incArray[4])

    /// lazy：延迟map的计算，只有在incArray1[0], incArray1[4]被调用时，才执行；而且只执行 第0和第4个元素，其他元素不参与计算
    let incArray1 = array.lazy.map(increment)
    print("Result:")
    print(incArray1[0], incArray1[4])

    /// 这样只有当 array[3] 被访问时，double(increment(array[3])) 才会被执行，被访问之前不会有这个计算，数组的其他元素也不会有这个计算！
    func double(x: Int) -> Int {
        print("Computing double value of \(x)…")
        return 2*x
    }
    let doubleArray = array.lazy.map(increment).map(double)
    print(doubleArray[3])
}
