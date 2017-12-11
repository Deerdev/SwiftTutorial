//
//  GCDBySwift.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/12/11.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Cocoa

class GCDBySwift: NSObject {

    func creaeQueue() {
        /// 1-创建队列
        // attributes:默认是串行队列
        let queue1 = DispatchQueue(label: "com.deerdev.gcd1")
//        let queue2 = DispatchQueue(label: "com.deerdev.gcd2",, qos: <#T##DispatchQoS#>, attributes: <#T##DispatchQueue.Attributes#>, autoreleaseFrequency: <#T##DispatchQueue.AutoreleaseFrequency#>, target: <#T##DispatchQueue?#>)
        queue1.async {
            debugPrint("异步执行")
        }
        
        DispatchQueue.main.async {
            debugPrint("主线程执行")
        }
        
        DispatchQueue.global().async {
            debugPrint("global queue执行")
        }
        /// 2-队列优先级Qos
        /*
         优先级从高到底
         userInteractive
         userInitiated
         default
         utility
         background
         unspecified
         */
        let queue3 = DispatchQueue(label: "com.deerdev.gcd3", qos: .userInteractive)
        let queue4 = DispatchQueue(label: "com.deerdev.gcd4", qos: .utility)
        
        queue3.async {
            // 优先级高
            for i in 0..<10 {
                debugPrint("1", i)
            }
        }
        
        queue4.async {
            for i in 0..<10 {
                debugPrint("2", i)
            }
        }
        
        for i in 0..<10 {
            // 优先级最高
            debugPrint("main", i)
        }
        /*
         log仅供参考
         "main" 0
         "1" 0
         "2" 0
         "main" 1
         "1" 1
         "2" 1
         "main" 2
         "1" 2
         "2" 2
         "main" 3
         "1" 3
         "main" 4
         "1" 4
         "2" 3
         "main" 5
         "1" 5
         "2" 4
         "main" 6
         "1" 6
         "2" 5
         "main" 7
         "1" 7
         "2" 6
         "main" 8
         "1" 8
         "2" 7
         "main" 9
         "1" 9
         "2" 8
         "2" 9
         */

        /// 3-并发队列
        /*
         // 并发
         .concurrent
         // 需要手动触发
         .initiallyInactive
        */
        // 串行
        let queue5 = DispatchQueue(label: "com.deerdev.gcd5", qos: .utility, attributes: .initiallyInactive)
        // 并行
        let queue6 = DispatchQueue(label: "com.deerdev.gcd6", qos: .utility, attributes: [.initiallyInactive, .concurrent])
        
        queue5.async {
            for i in 0..<5 {
                debugPrint("5-1:", i)
            }
        }
        queue5.async {
            for i in 0..<5 {
                debugPrint("5-2:", i)
            }
        }
        
        queue6.async {
            for i in 0..<5 {
                debugPrint("6-1:", i)
            }
        }
        queue6.async {
            for i in 0..<5 {
                debugPrint("6-2:", i)
            }
        }
        queue5.activate()
        queue6.activate()
        /*
         "5-1:" 0
         "5-1:" 1
         "6-2:" 0
         "6-1:" 0
         "5-1:" 2
         "6-2:" 1
         "6-1:" 1
         "5-1:" 3
         "6-2:" 2
         "6-1:" 2
         "5-1:" 4
         "6-2:" 3
         "6-1:" 3
         "5-2:" 0
         "6-2:" 4
         "6-1:" 4
         "5-2:" 1
         */
        
        /// 4-延迟执行
        /*
         微妙
         .microseconds
         毫秒
         .milliseconds
         秒
         .seconds
         
         */
        let additionalTime: DispatchTimeInterval = .seconds(2)
        queue1.asyncAfter(deadline: .now() + additionalTime) {
            debugPrint("延迟2s执行")
        }
        
        /// 5-DispatchWorkItem: 代码执行块，可以放到任意队列执行
        var i = 0
        let workItem = DispatchWorkItem {
            i += 666
        }
        // workItem.perform()
        DispatchQueue.global().async {
            workItem.perform()
        }
        
        // 执行完成后，通知
        workItem.notify(queue: DispatchQueue.main) {
            debugPrint("通知主线程：任务执行完成，value=\(i)")
        }
        
//        DispatchQueue.global().async(execute: workItem)
        
        
        /// 5- DispatchGroup: 执行完所有任务后，再执行某种操作
        let queueGroup = DispatchGroup()
        let queue7 = DispatchQueue(label: "com.deerdev.gcd7")
        let queue8 = DispatchQueue(label: "com.deerdev.gcd8")
        queue7.async(group: queueGroup) {
            debugPrint("执行任务1")
        }
        queue8.async(group: queueGroup) {
            debugPrint("执行任务2")
        }
        
        queueGroup.notify(queue: DispatchQueue.main) {
            debugPrint("任务1&任务2 都执行完成")
        }
        
    }
}
