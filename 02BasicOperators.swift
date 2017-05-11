//
//  02BasicOperators.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/2/1.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

func basicOperators() -> Void {
    
    /// 1.取余
    let x1 = 9 % 4
    // -1
    let x2 = -9 % 4
    // 1 (取余数的负号被忽略)
    let x3 = 9 % -4
    
    // 可以对小数去除，x4 = 0.5，%号在swift3中被取消
    let x4 = 8.truncatingRemainder(dividingBy: 2.5)
    print("取余：x1=\(x1); x2=\(x2); x3=\(x3); x4=\(x4)")
    
    /// 2.元组比较
    if (3, "a") < (3, "b") {
        print("(3, \"a\") < (3, \"b\")")
    }
    if (3, "a") == (3, "a") {
        print("(3, \"a\") == (3, \"a\")")
    }
    
    
    /// 3.空合运算符 ?? (nil coalescing operator)
    var a: Int?
    // ??两边+空格
    //let x = a??2 ❌
    
    // 如果a=nil, x=2; 如果a!=nil, x=a
    let x = a ?? 2
    // 等同于：【 a != nil ? a! : 2 】
    print("??: x=\(x)")
    
    ///区间运算符...  ..<
    // 区间包括5
    for index in 1...5 {
        print("\(index) times 5 is \(index * 5)")
    }
    // 区间不包括5
    for index in 1..<5 {
        print("\(index) times 5 is \(index * 4)")
    }
    
    /// 4.三目运算符
    let xx = 10
    xx > 5 ? print("big") : print("little")
    // ()表示 "空处理"
    xx > 3 ? print("big") : ()
}
