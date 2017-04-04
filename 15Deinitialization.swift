//
//  15Deinitialization.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/2.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

/// 析构函数
// 每个类最多只能有一个析构器，而且析构器不带任何参数

//deinit {
//    // perform the deinitialization
//}


class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    
    // 析构函数
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
