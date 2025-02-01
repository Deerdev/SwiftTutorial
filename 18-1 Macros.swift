/// Swift 有两种宏:
// 独立宏（Freestanding macros） 可单独出现，无需被附加到任何声明中。
// 附加宏（Attached macros） 会修改它被附加到的声明。

/// 独立宏 freestanding
// 调用独立宏，需要在其名称前写入井号 (#)，并在名称后的括号中写入宏的参数
// #function 调用了 Swift 标准库中的 function() 宏
// #warning 调用了 Swift 标准库中的 warning(_:) 宏
func myFunction() {
  print("Currently running \(#function)")
  #warning("Something's wrong")
}

/// 附加宏 attached
// 调用附加宏，需要在其名称前写入 at 符号 (@) ，并在名称后的括号中写入宏的参数。
@OptionSet<Int>
struct SundaeToppings {
  private enum Options: Int {
    case nuts
    case cherry
    case fudge
  }
}
/**
@OptionSet 宏会读取私有枚举类中的枚举值列表，并为其中的每个值生成常量列表，同时也会为结构体增加对 OptionSet 协议的遵循。

宏展开效果：
```swift
struct SundaeToppings {
    private enum Options: Int {
        case nuts
        case cherry
        case fudge
    }


    typealias RawValue = Int
    var rawValue: RawValue
    init() { self.rawValue = 0 }
    init(rawValue: RawValue) { self.rawValue = rawValue }
    static let nuts: Self = Self(rawValue: 1 << Options.nuts.rawValue)
    static let cherry: Self = Self(rawValue: 1 << Options.cherry.rawValue)
    static let fudge: Self = Self(rawValue: 1 << Options.fudge.rawValue)
}
extension SundaeToppings: OptionSet { }
```
*/

/**
attached
将 attached 特性应用于宏声明。该特性的参数指示宏的角色。对于具有多个角色的宏，针对每个角色多次应用 attached 宏，每个角色应用一次。

特性的第一个参数指明宏的角色：特性的第一个参数指明宏的角色：

- Peer 宏：将 peer 作为此特性的第一个参数。实现该宏的类型遵循 PeerMacro 协议。这些宏在与宏附加的声明相同的作用域中生成新的声明。例如，将 peer 宏应用于结构体的方法可以在该结构体上定义额外的方法和属性。
- Member 宏：将 member 作为此特性的第一个参数。实现该宏的类型遵循 MemberMacro 协议。这些宏生成的新声明是该宏所附加的类型或扩展的成员。例如，将 member 宏应用于结构体声明可以在该结构体上定义额外的方法和属性。
- Member 特性：将 memberAttribute 作为此特性的第一个参数。实现该宏的类型遵循 MemberAttributeMacro 协议。这些宏将特性添加到该宏所附加的类型或扩展的成员上。
- Accessor 宏：将 accessor 作为此特性的第一个参数。实现该宏的类型遵循 AccessorMacro 协议。这些宏为它们附加的存储属性添加访问器，将其转换为计算属性。
- Extension 扩展宏：将 extension 作为此特性的第一个参数。实现宏的类型遵循 ExtensionMacro 协议。这些宏可以添加协议遵循、where 从句，以及宏所附加到的类型的成员的新声明。如果宏添加了协议遵循，请包含 conformances: 参数并指定这些协议。遵循列表包含协议名称、指向遵循列表项的类型别名，或者是遵循列表项的协议组合。嵌套类型上的扩展宏会展开为该文件顶层的扩展。你不能在扩展、类型别名或嵌套在函数内的类型上编写扩展宏，也不能使用扩展宏添加具有 peer 宏的扩展。

peer、member 和 accessor 宏角色需要一个 names: 参数，列出宏生成的符号名称。如果宏在扩展内部添加声明，扩展宏角色也需要一个 names: 参数。当宏声明包含 names: 参数时，宏实现必须仅生成与该列表匹配的名称的符号。也就是说，宏不必为每个列出的名称生成符号。该参数的值是以下一个或多个项的列表：

- named(<#name#>) 其中 name 是那个固定的符号名称，用于一个已知的名称。
- overloaded 用于与现有符号同名的名称。
- prefixed(<#prefix#>) 其中 prefix 被添加到符号名称前，用于以固定字符串开头的名称。
- suffixed(<#suffix#>) 其中 suffix 被附加到符号名称后，用于以固定字符串结尾的名称。
- arbitrary 用于一个在宏展开之前无法确定的名称。

作为一个特殊情况，你可以为一个行为类似于属性包装器的宏编写 prefixed($)。
*/

/**
names 参数可以有以下几种值：

1. named(<#name#>) - 用于指定一个固定的符号名称
@attached(peer, names: named(description))
struct Example1 { }  // 生成的符号名称一定是 "description"

2. overloaded - 用于与现有符号同名的名称
@attached(peer, names: overloaded)
struct Example2 { }  // 生成的符号可能与现有符号同名

3. prefixed(<#prefix#>) - 用于以固定字符串开头的名称
@attached(peer, names: prefixed("validate"))
struct Example3 { }  // 生成的符号名称会以 "validate" 开头

4. suffixed(<#suffix#>) - 用于以固定字符串结尾的名称
@attached(peer, names: suffixed("Property"))
struct Example4 { }  // 生成的符号名称会以 "Property" 结尾

5. arbitrary - 用于在宏展开之前无法确定的名称
@attached(peer, names: arbitrary)
struct Example5 { }  // 生成的符号名称是动态确定的

特殊情况：
prefixed($) - 专门用于行为类似属性包装器的宏
@attached(peer, names: prefixed($))
struct Example6 { }  // 生成的符号名称会以 $ 开头
*/

/// ✅ peer
// peer 宏的强大之处在于可以根据需要自动生成这些协议的具体实现，减少样板代码
// 定义宏，明确指定要生成的协议
// names: arbitrary 表示宏生成的符号名称在宏展开之前无法确定
// 这里使用 arbitrary 是因为宏会生成多个不同的符号名称（比如 hash(into:)、==、encode 等方法），这些名称在宏展开前是无法确定的

/**
peer 宏的主要作用是：
在与原始声明相同的作用域中生成新的声明（比如扩展、方法、属性等）

主要用途：
1. 自动生成协议遵循
2. 添加辅助方法
3. 生成相关的类型或扩展
*/

// 1. 定义一个生成协议遵循的宏
@attached(peer, names: arbitrary)
@attached(extension, conformances: Equatable, Hashable, Codable)
public macro AutoGenerateProtocols() =
  #externalMacro(module: "MyMacros", type: "AutoGenerateProtocolsMacro")

// 正确使用方式
@AutoGenerateProtocols
struct Person {
  let name: String
  let age: Int
}

// 2. 定义一个生成辅助方法的宏
@attached(peer, names: named(toDict))
public macro GenerateDictionaryConversion() =
  #externalMacro(module: "MyMacros", type: "DictionaryConversionMacro")

// 正确使用方式
@GenerateDictionaryConversion
struct Product {
  let name: String
  let price: Double
}
/**
宏展开后可能生成：
extension Product {
    func toDict() -> [String: Any] {
        return ["name": name, "price": price]
    }
}
*/

// 3. 定义一个生成相关类型的宏
@attached(peer, names: prefixed("Mutable"))
public macro GenerateMutableType() = #externalMacro(module: "MyMacros", type: "MutableTypeMacro")

// 正确使用方式
@GenerateMutableType
struct Configuration {
  let serverURL: String
  let timeout: Int
}
/**
宏展开后可能生成：
struct MutableConfiguration {
    var serverURL: String
    var timeout: Int
}
*/

/**
peer 宏的优势：
1. 减少样板代码 - 自动生成重复性的代码
2. 保持一致性 - 确保生成的代码遵循相同的模式
3. 提高可维护性 - 集中管理相关的代码生成逻辑
4. 降低错误风险 - 自动生成的代码比手动编写更不容易出错
*/
/**
宏的实现示例（在 MyMacros 模块中）：

// AutoGenerateProtocolsMacro.swift
public struct AutoGenerateProtocolsMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 生成协议遵循的实现
        return [
            // 返回生成的扩展声明
        ]
    }
}

// DictionaryConversionMacro.swift
public struct DictionaryConversionMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 生成 toDict 方法的实现
        let extensionDecl = """
        extension Product {
            func toDict() -> [String: Any] {
                return ["name": name, "price": price]
            }
        }
        """
        return [DeclSyntax(stringLiteral: extensionDecl)]
    }
}

// MutableTypeMacro.swift
public struct MutableTypeMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 生成可变类型的实现
        let mutableTypeDecl = """
        struct MutableConfiguration {
            var serverURL: String
            var timeout: Int
        }
        """
        return [DeclSyntax(stringLiteral: mutableTypeDecl)]
    }
}
*/

/// ✅ member
// member 宏用于在类型内部生成新的成员（属性、方法等）
/**
member 宏生成的声明在类型内部
peer 宏生成的声明在类型外部（同级作用域）
*/

/**
member 宏常用于：
生成便利属性和方法
添加派生的计算属性
实现辅助功能
自动生成常用的工具方法
*/

// 示例1：生成计算属性
@attached(member, names: named(isAdult))
public macro PersonProperties() = #externalMacro(module: "MyMacros", type: "PersonPropertiesMacro")

@PersonProperties  // 使用定义好的宏
struct Person {
  let age: Int
}
/**
宏展开效果：
struct Person {
    let age: Int

    // 生成的成员属性
    var isAdult: Bool {
        return age >= 18
    }
}
*/

// 示例2：生成多个成员
@attached(member, names: [named(fullName), named(initials)])
public macro UserProperties() = #externalMacro(module: "MyMacros", type: "UserPropertiesMacro")

// 正确的使用方式
@UserProperties  // 使用定义好的宏
struct User {
  let firstName: String
  let lastName: String
}
/**
宏展开效果：
struct User {
    let firstName: String
    let lastName: String

    // 生成的成员属性
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    var initials: String {
        return "\(firstName.prefix(1))\(lastName.prefix(1))"
    }
}
*/

// 示例3：生成便利方法
@attached(member, names: named(clear))
public macro CacheOperations() = #externalMacro(module: "MyMacros", type: "CacheOperationsMacro")

@CacheOperations  // 使用定义好的宏
struct Cache {
  private var storage: [String: Any]
}
/**
宏展开效果：
struct Cache {
    private var storage: [String: Any]

    // 生成的成员方法
    mutating func clear() {
        storage.removeAll()
    }
}
*/

// 示例4：生成计算属性和方法的组合
@attached(member, names: [named(isEmpty), named(add), named(remove)])
public macro StackOperations() = #externalMacro(module: "MyMacros", type: "StackOperationsMacro")

@StackOperations  // 使用定义好的宏
struct Stack<T> {
  private var items: [T]
}
/**
宏展开效果：
struct Stack<T> {
    private var items: [T]

    // 生成的成员
    var isEmpty: Bool {
        return items.isEmpty
    }

    mutating func add(_ item: T) {
        items.append(item)
    }

    mutating func remove() -> T? {
        return items.popLast()
    }
}
*/

/**
member 宏的特点：
1. 在类型内部生成新的成员
2. 可以生成属性、方法、嵌套类型等
3. 生成的成员可以访问类型的其他成员
4. 需要通过 names 参数指定生成的成员名称
*/

// 1.声明宏
@attached(member, names: [named(fullName), named(initials)])
public macro UserProperties() = #externalMacro(module: "MyMacros", type: "UserPropertiesMacro")

// 2. 在宏的实现模块中，需要定义具体的实现逻辑
// MyMacros/UserPropertiesMacro.swift
public struct UserPropertiesMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    // 生成 fullName 属性
    let fullNameProperty = """
      var fullName: String {
          return "\\(firstName) \\(lastName)"
      }
      """

    // 生成 initials 属性
    let initialsProperty = """
      var initials: String {
          return "\\(firstName.prefix(1))\\(lastName.prefix(1))"
      }
      """

    // 返回生成的成员声明
    return [
      DeclSyntax(stringLiteral: fullNameProperty),
      DeclSyntax(stringLiteral: initialsProperty),
    ]
  }
}

/// ✅ memberAttribute
// 为成员添加特性
/**
member 宏：直接在类型中生成新的成员（如属性、方法等） - 修饰在类型上
memberAttribute 宏：为现有成员添加特性（attribute），通常用于修改或增强现有成员的行为 - 修饰在属性、成员上
*/

// 1. 定义一个验证属性的宏
@attached(memberAttribute)
public macro Validate<T: Comparable>(minimum: T, maximum: T) =
  #externalMacro(module: "MyMacros", type: "ValidateMacro")

// 正确使用方式
struct User {
  @Validate(minimum: 0, maximum: 150)
  var age: Int

  @Validate(minimum: 1, maximum: 100)
  var score: Double
}

/**
宏展开效果：
struct User {
    private var _age: Int
    var age: Int {
        get { _age }
        set {
            precondition(newValue >= 0 && newValue <= 150,
                "Age must be between 0 and 150")
            _age = newValue
        }
    }

    private var _score: Double
    var score: Double {
        get { _score }
        set {
            precondition(newValue >= 1 && newValue <= 100,
                "Score must be between 1 and 100")
            _score = newValue
        }
    }
}
*/

// 2. 定义一个日志记录宏
@attached(memberAttribute)
public macro Logged() = #externalMacro(module: "MyMacros", type: "LoggedMacro")

// 正确使用方式
class BankAccount {
  var balance: Double

  @Logged
  func withdraw(amount: Double) {
    balance -= amount
  }
}

/**
宏展开效果：
class BankAccount {
    var balance: Double

    func withdraw(amount: Double) {
        print("开始执行 withdraw 方法，参数：amount = \(amount)")
        balance -= amount
        print("withdraw 方法执行完成")
    }
}
*/

// 3. 定义一个线程安全宏
@attached(memberAttribute)
public macro ThreadSafe() = #externalMacro(module: "MyMacros", type: "ThreadSafeMacro")

// 正确使用方式
class Cache {
  private let lock = NSLock()
  private var storage: [String: Any] = [:]

  @ThreadSafe
  func setValue(_ value: Any, forKey key: String) {
    storage[key] = value
  }
}

/**
宏展开效果：
class Cache {
    private let lock = NSLock()
    private var storage: [String: Any] = [:]

    func setValue(_ value: Any, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage[key] = value
    }
}
*/

/**
宏的实现示例（在 MyMacros 模块中）：

// ValidateMacro.swift
public struct ValidateMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclSyntaxProtocol,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        // 返回需要添加的属性特性
        return [
            // 实现验证逻辑
        ]
    }
}

// LoggedMacro.swift
public struct LoggedMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclSyntaxProtocol,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        // 返回需要添加的日志特性
        return [
            // 实现日志记录逻辑
        ]
    }
}

// ThreadSafeMacro.swift
public struct ThreadSafeMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclSyntaxProtocol,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        // 返回需要添加的线程安全特性
        return [
            // 实现线程安全逻辑
        ]
    }
}
*/

/**
使用示例：
let user = User()
user.age = 25     // 正常设置
// user.age = 200 // 会触发 precondition 错误

let account = BankAccount(balance: 1000)
account.withdraw(amount: 500) // 会打印日志

let cache = Cache()
cache.setValue("value", forKey: "key") // 线程安全的操作
*/

/// ✅ accessor
// 将 accessor 特性应用于宏声明。该特性指示宏生成访问器。
/**
提供默认值处理
添加值验证逻辑
实现类型转换
提供单位转换功能
*/
/**
accessor 宏：专门用于生成属性的访问器（getter/setter）
memberAttribute 宏：为成员添加特性，可以影响成员的各个方面（不仅限于访问器）
*/

// 1.带有默认值的属性访问器：
// 定义宏
@attached(accessor)
public macro DefaultValue(_ value: Int) =
  #externalMacro(module: "MyMacros", type: "DefaultValueMacro")

// 使用示例
struct Configuration {
  @DefaultValue(100)
  var timeout: Int
}

/**
宏展开效果：
struct Configuration {
    private var _timeout: Int?

    var timeout: Int {
        get {
            return _timeout ?? 100
        }
        set {
            _timeout = newValue
        }
    }
}
*/

// 2.带有值验证的属性访问器：
// 定义宏
@attached(accessor)
public macro ValidatedProperty<T: Comparable>(_ minimum: T, _ maximum: T) =
  #externalMacro(module: "MyMacros", type: "ValidatedPropertyMacro")

// 使用示例
struct Person {
  @ValidatedProperty(0, 150)
  var age: Int
}

/**
宏展开效果：
struct Person {
    private var _age: Int = 0

    var age: Int {
        get {
            return _age
        }
        set {
            guard newValue >= 0 && newValue <= 150 else {
                fatalError("年龄必须在 0-150 之间")
            }
            _age = newValue
        }
    }
}
*/

// 3.实现类型转换的属性访问器：
// 定义宏
@attached(accessor)
public macro StringConverted() = #externalMacro(module: "MyMacros", type: "StringConvertedMacro")

// 使用示例
struct Product {
  @StringConverted
  var price: Double
}

/**
宏展开效果：
struct Product {
    private var _price: Double = 0.0

    var price: Double {
        get {
            return _price
        }
        set {
            _price = newValue
        }
    }

    var priceString: String {
        get {
            return String(format: "%.2f", _price)
        }
        set {
            _price = Double(newValue) ?? 0.0
        }
    }
}
*/

// 4.提供单位转换的属性访问器：
// 定义宏
@attached(accessor)
public macro Temperature() = #externalMacro(module: "MyMacros", type: "TemperatureMacro")

// 使用示例
struct Weather {
  @Temperature
  var celsius: Double
}

/**
宏展开效果：
struct Weather {
    private var _celsius: Double = 0.0

    var celsius: Double {
        get { return _celsius }
        set { _celsius = newValue }
    }

    var fahrenheit: Double {
        get { return _celsius * 9/5 + 32 }
        set { _celsius = (newValue - 32) * 5/9 }
    }
}
*/
