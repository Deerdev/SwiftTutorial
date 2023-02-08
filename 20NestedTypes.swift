//
//  20NestedTypes.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/5.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// 1.嵌套类型

struct BlackjackCard {
    
    // 内嵌 枚举
    // nested Suit enumeration
    enum Suit: Character {
        case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
    }
    
    // nested Rank enumeration
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        
        // 内嵌结构体
        struct Values {
            let first: Int, second: Int?
        }
        
        var values: Values {
            switch self {
            case .Ace:
                return Values(first: 1, second: 11)
            case .Jack, .Queen, .King:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    // BlackjackCard properties and methods
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

func nestedTypeTest() {
    // 结构体逐一成员构造器
    let theAceOfSpades = BlackjackCard(rank: .Ace, suit: .Spades)
    print("theAceOfSpades: \(theAceOfSpades.description)")
    // Prints "theAceOfSpades: suit is ♠, value is 1 or 11"
    
    /// 2.引用嵌套类型 “Referring to Nested Types”
    // “在嵌套类型的类型名前加上其外部类型的类型名作为前缀”
    let heartsSymbol = BlackjackCard.Suit.Hearts.rawValue
    // heartsSymbol is "♡"
}









