//
//  25AdvancedOperators.swift
//  SwiftTutorial
//
//  Created by deerdev on 2017/4/6.
//  Copyright © 2017年 deerdev. All rights reserved.
//

import Foundation

/// Swift 默认不允许溢出，报错
// 允许溢出：使用溢出运算符 （&+ &- &*），以&开头

/// 1.运算符重载 Operator Methods
struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    /// 2.双目运算符 binary operator
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        // 返回新的 Vector2D 实例
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

extension Vector2D {
    /// 3.单目运算符，分前缀(prefix)，后缀(postfix)   unary operators
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

extension Vector2D {
    /// 4.复合赋值运算符 Compound Assignment Operators
    // 左参数 设置为 inout，左参数在运算符内被修改
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}

/// *** 不能对默认的赋值运算符（=）进行重载。只有组合赋值运算符可以被重载。同样地，也无法对三目条件运算符 （a ? b : c） 进行重载 ***

/// 5.等价运算符 Equivalence Operators
extension Vector2D {
    // 相等
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }

    // 不等
    static func != (left: Vector2D, right: Vector2D) -> Bool {
        return !(left == right)
    }
}

/// 6.自定义运算符 Custom Operators
// 新的运算符要使用 operator 关键字在全局作用域内进行定义，同时还要指定 prefix、infix 或者 postfix 修饰符：

// 首先在全局定义操作符

prefix operator +++

extension Vector2D {
    // 前缀 双自增
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}

/// 7.自定义中缀运算符的优先级  “Precedence for Custom Infix Operators”

// 赋予AdditionPrecedence优先级
infix operator +- : AdditionPrecedence

extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

// *** 当定义前缀与后缀运算符的时候，我们并没有指定优先级。然而，如果对同一个值同时使用前缀与后缀运算符，则后缀运算符会先参与运算 ***

// 优先级和结合性 Precedence and Associativity

/// -------------------------------
/// @resultBuilder（结果构建器）是Swift 5.4引入的一个重要特性，主要用于创建领域特定语言（DSL）。
/// 编写声明式代码，可以简化复杂逻辑的实现，提高代码的可读性和可维护性。
/// -------------------------------

// 1. 首先定义一些基础的SQL组件
struct SQLComponent {
    let sql: String
    let parameters: [Any]
}

// 2. 定义SQL构建器
@resultBuilder
struct SQLBuilder {
    // 处理基本语句
    static func buildBlock(_ components: SQLComponent...) -> SQLComponent {
        let sql = components.map { $0.sql }.joined(separator: " ")
        let parameters = components.flatMap { $0.parameters }
        return SQLComponent(sql: sql, parameters: parameters)
    }

    // 处理条件语句
    static func buildEither(first component: SQLComponent) -> SQLComponent {
        component
    }

    static func buildEither(second component: SQLComponent) -> SQLComponent {
        component
    }

    // 处理可选语句
    static func buildOptional(_ component: SQLComponent?) -> SQLComponent {
        component ?? SQLComponent(sql: "", parameters: [])
    }

    // 处理数组
    static func buildArray(_ components: [SQLComponent]) -> SQLComponent {
        let sql = components.map { $0.sql }.joined(separator: ", ")
        let parameters = components.flatMap { $0.parameters }
        return SQLComponent(sql: sql, parameters: parameters)
    }
}

// 3. 创建一些辅助函数
func SELECT(_ columns: String...) -> SQLComponent {
    SQLComponent(sql: "SELECT \(columns.joined(separator: ", "))", parameters: [])
}

func FROM(_ table: String) -> SQLComponent {
    SQLComponent(sql: "FROM \(table)", parameters: [])
}

func WHERE(_ condition: String, parameters: Any...) -> SQLComponent {
    SQLComponent(sql: "WHERE \(condition)", parameters: parameters)
}

func AND(_ condition: String, parameters: Any...) -> SQLComponent {
    SQLComponent(sql: "AND \(condition)", parameters: parameters)
}

func ORDER_BY(_ columns: String...) -> SQLComponent {
    SQLComponent(sql: "ORDER BY \(columns.joined(separator: ", "))", parameters: [])
}

// 4. 使用SQL构建器创建查询
@SQLBuilder
func buildUserQuery(minAge: Int, nameFilter: String?) -> SQLComponent {
    SELECT("id", "name", "age", "email")
    FROM("users")
    WHERE("age >= ?", parameters: minAge)

    // 条件查询
    if let name = nameFilter {
        AND("name LIKE ?", parameters: "%\(name)%")
    }

    ORDER_BY("age DESC", "name ASC")
}

// 5. 创建查询执行器
class SQLQueryExecutor {
    func execute(_ component: SQLComponent) {
        print("SQL: \(component.sql)")
        print("Parameters: \(component.parameters)")
    }
}

// 6. 使用示例
let executor = SQLQueryExecutor()

// 示例1：基本查询
let query1 = buildUserQuery(minAge: 18, nameFilter: nil)
executor.execute(query1)
// 输出:
// SQL: SELECT id, name, age, email FROM users WHERE age >= ? ORDER BY age DESC, name ASC
// Parameters: [18]

// 示例2：带名字过滤的查询
let query2 = buildUserQuery(minAge: 25, nameFilter: "张")
executor.execute(query2)
// 输出:
// SQL: SELECT id, name, age, email FROM users WHERE age >= ? AND name LIKE ? ORDER BY age DESC, name ASC
// Parameters: [25, "%张%"]

// 7. 扩展更复杂的查询示例
@SQLBuilder
func buildComplexQuery(
    departments: [String],
    minSalary: Double,
    isActive: Bool
) -> SQLComponent {
    SELECT("e.id", "e.name", "d.department_name", "e.salary")
    FROM("employees e")
    "JOIN departments d ON e.department_id = d.id"
    WHERE("e.salary >= ?", parameters: minSalary)

    if !departments.isEmpty {
        "AND d.department_name IN ("
        for department in departments {
            "?"
        }
        ")"
    }

    if isActive {
        AND("e.status = ?", parameters: "active")
    }

    ORDER_BY("e.salary DESC")
}

// 使用复杂查询
let complexQuery = buildComplexQuery(
    departments: ["技术部", "市场部"],
    minSalary: 10000,
    isActive: true
)
executor.execute(complexQuery)
// 输出:
// SQL: SELECT e.id, e.name, d.department_name, e.salary FROM employees e
//      JOIN departments d ON e.department_id = d.id
//      WHERE e.salary >= ? AND d.department_name IN (?, ?)
//      AND e.status = ? ORDER BY e.salary DESC
// Parameters: [10000, "技术部", "市场部", "active"]

// `buildArray`和`buildBlock`的区别：

// 1. **buildBlock**：
// - 用于处理固定数量的连续语句
// - 在普通的代码块中使用
// - 编译器自动调用

// buildBlock的典型实现
static func buildBlock(_ components: Component...) -> Component {
    // 处理固定的连续语句
    return Component(components.joined())
}

// 使用示例
@MyBuilder
func example() -> Component {
    component1  // 这些连续的语句会被
    component2  // 传递给buildBlock
    component3
}

// 2. **buildArray**：
// - 用于处理循环语句（for循环）中的动态内容
// - 处理数组或集合
// - 当使用for循环时自动调用

// buildArray的典型实现
static func buildArray(_ components: [Component]) -> Component {
    // 处理动态数量的组件
    return Component(components.joined())
}

// 使用示例
@MyBuilder
func example(items: [String]) -> Component {
    // 这个for循环会触发buildArray
    for item in items {
        Component(item)
    }
}

// 让我们用一个具体的例子来说明区别：

// 1. 定义基础组件
struct HTMLComponent {
    let content: String
}

// 2. 定义构建器
@resultBuilder
struct HTMLBuilder {
    // 处理固定的连续语句
    static func buildBlock(_ components: HTMLComponent...) -> HTMLComponent {
        HTMLComponent(content: components.map { $0.content }.joined(separator: "\n"))
    }

    // 处理循环生成的内容
    static func buildArray(_ components: [HTMLComponent]) -> HTMLComponent {
        HTMLComponent(content: components.map { $0.content }.joined(separator: "\n"))
    }
}

// 3. 辅助函数
func div(_ content: String) -> HTMLComponent {
    HTMLComponent(content: "<div>\(content)</div>")
}

// 4. 使用示例
@HTMLBuilder
func createFixedHTML() -> HTMLComponent {
    // 使用buildBlock处理这些固定的连续语句
    div("标题")
    div("内容1")
    div("内容2")
}

@HTMLBuilder
func createDynamicHTML(items: [String]) -> HTMLComponent {
    div("标题")
    // 使用buildArray处理循环
    for item in items {
        div(item)
    }
    div("页脚")
}

// 5. 测试
let fixed = createFixedHTML()
print("固定内容：\n\(fixed.content)")
// 输出：
// <div>标题</div>
// <div>内容1</div>
// <div>内容2</div>

let dynamic = createDynamicHTML(items: ["项目1", "项目2", "项目3"])
print("\n动态内容：\n\(dynamic.content)")
// 输出：
// <div>标题</div>
// <div>项目1</div>
// <div>项目2</div>
// <div>项目3</div>
// <div>页脚</div>
