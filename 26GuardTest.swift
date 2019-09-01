//
//  26GuardTest.swift
//  Swift3Tutorial
//
//  Created by daoquan on 2017/5/11.
//  Copyright © 2017年 daoquan. All rights reserved.
//

import Foundation

enum Level: Int {
    case beginner = 1, intermediate, advanced
}

class Episode {
    // ...
    typealias EpisodeInfo = [String: String]
    
    var level: Level
    var title: String
    var urls: EpisodeInfo
    
    init(level: Level, title: String, urls: EpisodeInfo) {
        self.level = level
        self.title = title
        self.urls = urls
    }
    
    convenience init?(response: [String: Any]) {
        // guard一层一层解包（使用于网络json数据）
        guard let levelValue = response["level"] as? Int,
            let level = Level(rawValue: levelValue),
            let title = response["title"] as? String,
            let urls = response["urls"] as? EpisodeInfo
            else {
                return nil
        }
        
        self.init(level: level, title: title, urls: urls)
    }
}

/// guard不仅可以用return，还可以是break、continue
func testGuardElse() {
    let array = [1, 2, 3]
    for i in array {
        guard i > 2 else { continue }
        print(i)
    }
}
