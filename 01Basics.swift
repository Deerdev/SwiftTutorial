//
//  01Basics.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/1/30.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

func basicDefination() -> Void {
    var type: String = String()
    var red = 1, green = "aa", blue = 0.0
    var str = "swift"
    
    /// 如果使用关键字作为变量。添加反引号(`x`)
    var `var` = "var"
    
    print(red)
    // print默认换行，加terminator不换行
    print(green, terminator:"")
    print(blue, terminator:" ")
    print(`var`)
    
    /// 格式化输出字符串（字符串插值）
    print("I'm learing \(str)")
    
    /// 输出UInt8的最大最小值，适用于UInt16、UInt32等
    let minValue = UInt8.min
    let maxValue = UInt8.max
    print("UInt8：min = \(minValue); max = \(maxValue)")
    
    /// 区分数值"_"，增加可读性
    let x = 1_000_000_000
    print("Beautiful reading: \(x)")
    
    /// 类型别名
    typealias AudioSample = UInt16
    var maxAudioSample = UInt16.max
    print("macAudio : \(maxAudioSample)")
    
    /// if的判断条件只能是Bool型，Int不行（直接报错）
    /*
    if maxAudioSample {
 
    }
    */
    
    /// 元组
    let (code, message1) = ("code", "message")
    // 只取第二个变量
    let (_, message2) = ("code", "message")
    let codeStatus = (404, "error")
    let codeStatus2 = (statusCode:404, statusMessage:"error")
    print("Tuple1: \(codeStatus.0) - \(codeStatus.1)")
    print("Tuple2: \(codeStatus2.statusCode) - \(codeStatus2.statusMessage)")
    // 当【比较】两个Tuple类型的变量时，要遵循下面的规则：
    // -**- 首先，只有元素个数相同的Tuple变量之间，才能进行比较
    // -**- 最多包含6个元素的Tuple变量进行比较，超过这个数量，Swift会报错
    
    
    
    let possibleNumber = "123"
    /// convertedNumber是optional类型，因为返回Int()强制转换可能失败
    let convertedNumber = Int(possibleNumber)
    
    /// optional初始化，可不初始化，为nil
    /********
     *swift中的nil不是指针，是确定的值，任何值得可选状态都可以被置为nil
     *OC中的nil是指向一个不存在的对象
    ********/
    
    var error404: Int? = 404
    
    if convertedNumber != nil {
        print("操作 convertedNumber")
    }
    
    // *** let使用前必须初始化，没有默认初始化
    let optionNum1:Int?
    // *** var变量默认初始化为nil
    var optionNum2:Int?
    
    
    /// 确定convertedNumber有值（必须非nil），使用"!"强制解析optional（转为非optional）
    var number = convertedNumber!
    
    /// 可选绑定（optional binding）
    if let constNumber = Int(possibleNumber) {
        print("optional binding test")
    }
    
    
    /// 隐式解析可选类型
    
    // 使用!，而不是?，适用于：赋值一次，以后都会有值的optional
    // 在使用前，一定是已经完成初始化了
    // assumedString: 隐式可选类型
    let assumedString: String! = "xxx"
    
    // 不用使用!解析，直接赋值使用
    let implicitString: String = assumedString
    let implicitString2 = assumedString
    
    
    /// 错误处理
    /*
    func makeASandwich() throws {
        // ...
        
    }
    
    do {
        try makeASandwich()
        eatASandwich()
    } catch SandwichError.outOfCleanDishes {
        washDishes()
    } catch SandwichError.missingIngredients(let ingredients) {
        // 处理带错误参数
        buyGroceries(ingredients)
    }
    */
    
    /// 断言assertion
    let age = 3
    // 条件为真，继续运行；
    // 条件为假，停止运行，打印第二个参数
    assert(age >= 0, "A person's age can't be less than zero")

    /// ==========Swift4.2==========
    /// Bool .toggle(), 给Bool取反
    var aa = false
    aa.toggle() // True
}
