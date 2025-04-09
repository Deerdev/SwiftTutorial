
/// `if let a = a { }` 可以简写成 `if let a { }`

/// subscript(_, default:) 下标加默认值
func generateObject(identifier: String) {
    map[identifier, default: []].append(Object())
}

/// class 标记为 final, 这样相关方法在派发时将无需通过间接表