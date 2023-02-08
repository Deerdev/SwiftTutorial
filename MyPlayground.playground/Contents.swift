import UIKit

class A: NSObject {}

var doubleHashStr = ##"字符串内有"# 使用双#包括"##
print(doubleHashStr)
doubleHashStr = #"Line 1 \nLine 2"#
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

// 在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
// 创建 表达式（5+4）*2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
print("(5+4)*2 : \(product)")
