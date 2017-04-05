//
//  19TypeCasting.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/4/5.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}
let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// "library" 的类型被推断为[MediaItem]


/// 检查类型
// 检查操作符（ type check operator） 【is】
func typeCheckIS() {
    
    var movieCount = 0
    var songCount = 0
    
    for item in library {
        // 判断library的成员实际是哪个类型
        if item is Movie {
            movieCount += 1
        } else if item is Song {
            songCount += 1
        }
    }
}

/// 向下转换 Downcasting
// 某类型的一个常量或变量可能在幕后实际上属于一个子类。当确定是这种情况时，你可以尝试【向下转到它的子类型】，用类型转换操作符（as? 或 as!）
// as? 转为可选类型
// as! 强制解包

func downCastingAS() {
    for item in library {
        // 转为Movie？
        if let movie = item as? Movie {
            print("Movie: '\(movie.name)', dir. \(movie.director)")
        } else if let song = item as? Song {
            // 转为Song?
            print("Song: '\(song.name)', by \(song.artist)")
        }
    }
}

// 转换没有真的改变实例或它的值。根本的实例保持不变；只是简单地把它作为它被转换成的类型来使用。


/// Any和AnyObject的类型转换 “Type Casting for Any and AnyObject”

/**
 * Any 可以表示任何类型，包括函数类型。
 * AnyObject 可以表示任何类类型的实例。
**/

func anyAndAnyObject() {
    // Any的数组，存储任意类型的数据
    var things = [Any]()
    
    things.append(0)
    things.append(0.0)
    things.append(42)
    things.append(3.14159)
    things.append("hello")
    things.append((3.0, 5.0))
    things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
    things.append({ (name: String) -> String in "Hello, \(name)" })
    
    for thing in things {
        switch thing {
        case 0 as Int:
            print("zero as an Int")
        case 0 as Double:
            print("zero as a Double")
        case let someInt as Int:
            print("an integer value of \(someInt)")
        case let someDouble as Double where someDouble > 0:
            print("a positive double value of \(someDouble)")
        case is Double:
            print("some other double value that I don't want to print")
        case let someString as String:
            print("a string value of \"\(someString)\"")
        case let (x, y) as (Double, Double):
            print("an (x, y) point at \(x), \(y)")
        case let movie as Movie:
            print("a movie called '\(movie.name)', dir. \(movie.director)")
        case let stringConverter as (String) -> String:
            print(stringConverter("Michael"))
        default:
            print("something else")
        }
    }
    
    // zero as an Int
    // zero as a Double
    // an integer value of 42
    // a positive double value of 3.14159
    // a string value of "hello"
    // an (x, y) point at 3.0, 5.0
    // a movie called 'Ghostbusters', dir. Ivan Reitman
    // Hello, Michael
    
    
    
    // ** Any类型可以表示所有类型的值，包括可选类型。Swift 会在你用Any类型来表示一个可选值的时候，给你一个警告。
    // 如果 确实想使用 Any类型 来承载可选值，你可以使用 as 操作符显示转换为Any，如下所示：
    let optionalNumber: Int? = 3
    things.append(optionalNumber)        // Warning
    things.append(optionalNumber as Any) // No warning
}









