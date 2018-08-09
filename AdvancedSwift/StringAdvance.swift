//
//  StringAdvance.swift
//  SwiftTutorial
//
//  Created by daoquan on 2018/8/9.
//  Copyright © 2018年 daoquan. All rights reserved.
//

import Foundation

/// String 不⽀持随机访问，也就是说，跳到字 符串中某个随机的字符不是⼀个 O(1) 操作。当字符拥有可变宽度时，字符串并不知道第 n 个 字符到底存储在哪⼉，它必须查看这个字符前⾯的所有字符，才能最终确定对象字符的存储位 置，所以这不可能是⼀个 O(1) 操作。

/// ================ Unicode ==================================
/// 今天的 Unicode 是⼀个可变⻓格式。它的可变⻓特性有两种不同的意义：
/// - 由编码单元 (code unit) 组成 Unicode 标量 (Unicode scalar)；
/// - 由 Unicode 标量组成字符。

/// Unicode 数据可以被编码成许多不同宽度的【编码单元】
/// - Swift 将 UTF-16 和 UTF-8 的编码单元分别⽤ UInt16 和 UInt8 来 表⽰
/// - (它们被赋予了 Unicode.UTF16.CodeUnit 和 Unicode.UTF8.CodeUnit 的类型别名)

/// Unicode 中的【编码点】 (code point) 在 Unicode 编码空间中是介于 0 到 0x10FFFF (也就是⼗进 制的 1,114,111) 之间的⼀个单⼀值。
/// - 对于 UTF-32，⼀个编码点会占⽤⼀个编 码单元。
/// - 对于 UTF-8 ⼀个编码点会占⽤⼀⾄四个编码单元( 1-4个 8bit)。

// Unicode 标量和编码点在⼤部分情况下是同样的东西。除了在 0xD800–0xDFFF 之间范围⾥的 2,048 个 “代理” (surrogate) 编码点 (它们被⽤来标⽰成对的 UTF-16 编码的开头或者结尾) 之 外的所有编码点，都是 Unicode 标量

/// 【标量】: 在 Swift 字符串字⾯量中以 "\u{xxxx}" 来表⽰，其 中的 xxxx 是⼗六进制的数字
///      Unicode 标量在 Swift 中对应的类型是 Unicode.Scalar，它是⼀个对 UInt32 的封装类型。

/// 在⽤标量组成 “字符” 时，Unicode 依旧是⼀个可变宽度的格式。⽤⼾所认为的在屏幕上显⽰的 “单个字符” 可能仍需要由多个编码点组合⽽成。
/// ⽤⼾所认为的在屏幕上显⽰的 “单个字符” 可能仍需要由多个编码点组合⽽成。在 Unicode 中，这种从⽤⼾视⻆看到的字符有⼀个术 语，它叫做【扩展字位簇】 (extended grapheme cluster)。


/// 标准等价
// “é”的表示：
//          - “é”单一字符：U+00E9
//          - “é”两个字符拼接：⽤⼀个普通的字⺟ “e” 后⾯跟⼀个 U+0301 (组合尖⾳符) 来表达它
/// Unicode的规则 将这两种定义 认为是 【标准等价】

func unicodeEqualTest() {
    let single = "Pok\u{00E9}mon" // Pokémon
    let double = "Poke\u{0301}mon" // Pokémon
    single == double // true

    /// 深入底层 不相等
    single.utf16.count // 7
    double.utf16.count // 8
    /// 转换成NSString求length 也不相等
    /// 就 NSString ⽽⾔，会在 UTF-16 编码单元的层⾯上，按字⾯值做⼀次⽐较，⽽不会将不同字符“组合”起来的等价性纳⼊考虑。
    /// 如果真要进⾏ 标准的⽐较，你必须使⽤ NSString.compare(_:)
}

/// str[5]下标操作在Swift中不允许：因为整数的下标访问⽆法在常数时间内完成 (对于 Collection 协议 来说这也是个直观要求)，⽽且查找第 n 个 Character 的操作也必须要对它之前的所有字节进⾏ 检查。


/// =============== 子字符串 ================
func splitStringToSubString() {
    let poem = """
            Over the wintry
            forest, winds howl in rage
            with no leaves to blow.
            """
    let lines = poem.split(separator: "\n") // ["Over the wintry", "forest, winds howl in rage", "with no leaves to blow."]
    type(of: lines) // Array<Substring>

    let sentence = "The quick brown fox jumped over the lazy dog."
    sentence.wrapped(after: 15)
    /* The quick brown
     fox jumped over
     the lazy dog.
     */
}

extension String {
    /// 按字折行，每after个字符 一行
    func wrapped(after: Int = 70) -> String {
        var i = 0
        let lines = self.split(omittingEmptySubsequences: false) { character in
            switch character {
            case "\n",
                 " " where i >= after:
                i=0
                return true
            default:
                i += 1
                return false
            }
        }

        // joined : 再将split的字符串 拼接起来
        return lines.joined(separator: "\n")
    }
}

/// 接受含有多个分隔符的序列作为参数的版本
extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence] where Element == S.Element {
        return split { separators.contains($0) }
    }
}

// 按照 “,!”分割字符串
// "Hello, world!".split(separators: ",! ")
// ["Hello", "world"]


/// 不⿎励⻓期存储⼦字符串的根本原因在于，⼦字符串会⼀直持有整个原始字符串。
// 如果有⼀个 巨⼤的字符串，它的⼀个只表⽰单个字符的⼦字符串将会在内存中持有整个字符串。即使当原 字符串的⽣命周期本应该结束时，只要⼦字符串还存在，这部分内存就⽆法释放。⻓期存储⼦字 符串实际上会造成内存泄漏，由于原字符串还必须被持有在内存中，但是它们却不能再被访问。















