import UIKit

class A: NSObject {}

let doubleHashStr = ##"字符串内有"# 使用双#包括"##
print(doubleHashStr)

var aa = false
aa.toggle()

class C {
    @objc var n: A! = A()
}

func getProperty(object: AnyObject) {
    type(of: object)
    type(of: object.n)

    if let n = object.n {
        type(of: n)
    }

    if let n: A = object.n {
        type(of: n)
    }
}

getProperty(object: C())
