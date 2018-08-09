//
//  StructClassAdvance.swift
//  SwiftTutorial
//
//  Created by daoquan on 2018/8/9.
//  Copyright © 2018年 daoquan. All rights reserved.
//

import Foundation

func whatSwiftStructFor() {
    // 引用类型：奔溃
    let mutableArrayOC: NSMutableArray = [1,2,3]
    for _ in mutableArrayOC { mutableArrayOC.removeLastObject() }
    // 值类型：不会奔溃，且正常运行
    var mutableArray = [1, 2, 3]
    for _ in mutableArray { mutableArray.removeLast() }

    /// 对结构体成员的修改 也会触发 didSet 属性监听方法
    /// 修改成员 == 修改结构体

    /// 实际上，mutating 标记的 ⽅法也就是结构体上的普通⽅法，只不过隐式的 self 被标记为了 inout ⽽已
    /*
    func translateByTwentyTwenty(rectangle: inout Rectangle) {
        rectangle.translate(by: Point(x: 20, y: 20))
    }
    */

    /// 写时复制。它的⼯作⽅式是，每当数组被改变，它⾸先检查它对存储缓冲区 的引⽤是否是唯⼀的，或者说，检查数组本⾝是不是这块缓冲区的唯⼀拥有者。如果是，那么 缓冲区可以进⾏原地变更；也不会有复制被进⾏。不过，如果缓冲区有⼀个以上的持有者 (如本 例中)，那么数组就需要先进⾏复制，然后对复制的值进⾏变化，⽽保持其他的持有者不受影响。

    /// 结合 16AutomaticReferenceCounting.swift
    
}
