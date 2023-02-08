//
//  ClassMemeryTest.swift
//  SwiftTutorial
//
//  Created by walt.lu on 2019/8/28.
//  Copyright © 2019 deerdev. All rights reserved.
//

import Cocoa

class BaseTest: NSObject {
    func BaseTest(name: String) -> String {
        return name
    }
}

class ClassMemeryTest: NSObject {
    var index = 0x0000111122223333
    func hello(name: String = "deer") {
        print("hello \(name)")
    }

    static func info() -> String {
        return "memery test"
    }

    @objc dynamic func dynamicTest() {
        print("dynamic")
    }
}
