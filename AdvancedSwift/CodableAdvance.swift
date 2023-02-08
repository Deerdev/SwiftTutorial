//
//  CodableAdvance.swift
//  SwiftTutorial
//
//  Created by deerdev on 2018/8/9.
//  Copyright © 2018年 deerdev. All rights reserved.
//

#if canImport(UIKit)
import UIKit
public typealias OSColor = UIColor
#endif

#if canImport(Cocoa)
import Cocoa
public typealias OSColor = NSColor
#endif

struct Coordinate: Codable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}

import Foundation
import CoreLocation

/// =========== 让不支持Codable的类型 支持Codable =============
/// 1.封装新的CodingKeys
struct Placemark5: Codable {
    var name: String
    var coordinate: CLLocationCoordinate2D
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name) // 分别编码纬度和经度
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name) // 从纬度和经度重新构建 CLLocationCoordinate2D
        self.coordinate = CLLocationCoordinate2D( latitude: try container.decode(Double.self, forKey: .latitude), longitude: try container.decode(Double.self, forKey: .longitude) )
    }
}

/// 2.嵌套容器
struct Placemark6: Encodable {

    var name: String
    var coordinate: CLLocationCoordinate2D

    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }

    // 嵌套容器的编码键
    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var coordinateContainer = container.nestedContainer( keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
}


/// 3.使用计算属性，让CLLocationCoordinate2D满足Codable
struct Placemark7: Codable {
    var name: String
    private var _coordinate: Coordinate
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: _coordinate.latitude, longitude: _coordinate.longitude)
        } set {
            _coordinate = Coordinate(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case _coordinate = "coordinate"
    }

}

/// =========== 为 类(比如UIColor) 添加Codable =============
// 在 Swift 4 中，我们不能为⼀个⾮ final 的类添加 Codable 特性
// 只有必须的初始化⽅法 (required initializers) 能满⾜协议的要求，⽽这类必须的初始化⽅法不能在扩展中进⾏添加； 它们必须直接在类的定义中直接进⾏声明。(扩展添加Codable无法实现 decode encode初始化方法，都是required的)
// 推荐的⽅式是写⼀个结构体来封装 UIColor，并且对这个结构体进⾏编解码
extension OSColor {

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // macos: This method works only with objects representing colors in the calibratedRGB or deviceRGB color space. Sending it to other objects raises an exception.
        // macos上是void方法，ios上是 bool返回
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if red < 0 || green < 0 || blue < 0 || alpha < 0 {
            return nil
        }
        return (red: red, green: green, blue: blue, alpha: alpha)
    }

}

// 定义包裹 结构体
extension OSColor {

    struct CodableWrapper: Codable {
        var value: OSColor

        init(_ value: OSColor) { self.value = value }

        enum CodingKeys: CodingKey {
            case red
            case green
            case blue
            case alpha
        }

        func encode(to encoder: Encoder) throws { // 如果颜⾊不能转为 RGBA，则抛出错误
            guard let (red, green, blue, alpha) = value.rgba else {
                let errorContext = EncodingError.Context( codingPath: encoder.codingPath, debugDescription:
                    "Unsupported color format: \(value)" )
                throw EncodingError.invalidValue(value, errorContext)
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(alpha, forKey: .alpha)
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let red = try container.decode(CGFloat.self, forKey: .red)
            let green = try container.decode(CGFloat.self, forKey: .green)
            let blue = try container.decode(CGFloat.self, forKey: .blue)
            let alpha = try container.decode(CGFloat.self, forKey: .alpha)
            self.value = OSColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

// 通过计算属性的方法，封装好UIColor
struct ColoredRect: Codable {
    var rect: CGRect // 对颜⾊进⾏存储

    private var _color: OSColor.CodableWrapper
    var color: OSColor {
        get { return _color.value }
        set { _color.value = newValue }
    }

    init(rect: CGRect, color: OSColor) {
        self.rect = rect
        self._color = OSColor.CodableWrapper(color)
    }

    private enum CodingKeys: String, CodingKey {
        case rect
        case _color = "color"
    }
}



/// =========== 枚举添加Codable =============
enum Either<A: Codable, B: Codable>: Codable {
    case left(A)
    case right(B)

    private enum CodingKeys: CodingKey {
        case left
        case right
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right) }

    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 不是左值 就是 右值
        if let leftValue = try container.decodeIfPresent(A.self, forKey: .left) {
            self = .left(leftValue)
        } else {
            let rightValue = try container.decode(B.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}

// xml 的编解码
func codableEnumTest() {
    let values: [Either<String, Int>] = [ .left("Forty-two"), .right(42) ]

    do {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let xmlData = try encoder.encode(values)
        let xmlString = String(decoding: xmlData, as: UTF8.self)
        /* <?xml version="1.0" encoding="UTF-8"?> <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"> <plist version="1.0"> <array>

         <dict> <key>left</key> <string>Forty-two</string>

         </dict>

         <dict> <key>right</key> <integer>42</integer>

         </dict> </array> </plist> */

        let decoder = PropertyListDecoder()
        let decoded = try decoder.decode([Either<String, Int>].self, from: xmlData)
        /* [Either<Swift.String, Swift.Int>.left("Forty-two"), Either<Swift.String, Swift.Int>.right(42)] */

    } catch {
        print(error.localizedDescription)
    }
}

/// =========== 解码多态集合 =============

/*
 let views: [UIView] = [label, imageView, button]
 在解码时，只会调用UIView的解码方法，所得到的东西和原来的形式会有不同 - 数 组中元素的具体类型⽆法保留。解码器只会给出普通的 UIView 对象，因为它只知道被解码的 数据类型⼀定是 [UIView].self。

 最好的⽅式是对每个我们想要⽀持的 ⼦类创建⼀个枚举成员。枚举的关联值中存储的是实际的对象：
 enum View {
     case view(UIView)
     case label(UILabel)
     case imageView(UIImageView)
    // ...
 }

 接下来，我们需要⼿写⼀个 Codable 的实现，它和之前我们在 Either 枚举中做的事情遵循同样 的模式：
    → 在编码过程中，对要编码的对象在所有枚举成员上做 switch 来找到我们要编码的类型。 然后将对象的类型和对象本⾝编码到它们的键中。
    → 在解码过程中，先解码类型信息，然后根据具体的类型选择合适的初始化⽅法。

 最后，我们可以写两个简便⽅法，来把⼀个 UIView 包装到 View 的值中，以及将 View 的值解 包成 UIView。这样，只⽤单个 map，我们就能把原始数组传递给编码器，以及从解码器中将它 们取出来了。

 这并不是⼀个动态的解决⽅案；每次我们想要⽀持新的⼦类时，都需要⼿动更新 View 枚举。这 不是很⽅便，但是却情有可原，因为我们必须明确地告诉解码器代码中所能接受的每个类型的 名字。其他⽅式可能会带来潜在的安全威胁，因为那样的话，攻击者可能可以操作程序包来初 始化⼀些我们程序⾥未知的对象
 */

// http://davelyon.net/2017/08/16/jsondecoder-in-the-real-world
// https://github.com/pointfreeco/swift-quickcheck/pull/2
// https://gist.github.com/phausler/6c61343a609aeeb9a8f890f1fe2acc17




