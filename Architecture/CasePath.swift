public struct CasePath<Root, Value> {
  public let extract: (Root) -> Value?
  public let embed: (Value) -> Root

  public init(extract: @escaping (Root) -> Value?, embed: @escaping (Value) -> Root) {
    self.extract = extract
    self.embed = embed
  }

  public init(_ embed: @escaping (Value) -> Root) {
    self.embed = embed
    self.extract = { root in extractHelp(case: embed, from: root) }
  }

  public func appending<AppendedValue>(path: CasePath<Value, AppendedValue>) -> CasePath<Root, AppendedValue> {
    return CasePath<Root, AppendedValue>(
      extract: { self.extract($0).flatMap(path.extract) },
      embed: { self.embed(path.embed($0)) }
    )
  }
}

extension CasePath where Root == Value {
  static var `self`: CasePath {
    return CasePath(extract: { .some($0) },
                    embed: {$0 })
  }
}

func extractHelp<Root, Value>(
  case: (Value) -> Root,
  from root: Root
) -> Value? {
  func reflect(_ root: Root) -> ([String?], Value)? {
    let mirror = Mirror(reflecting: root)
    guard let child = mirror.children.first else {
      return nil
    }

    if let value = child.value as? Value {
      return ([child.label], value)
    }

    let newMirror = Mirror(reflecting: child.value)
    guard let newChild = newMirror.children.first else {
      return nil
    }

    if let value = newChild.value as? Value {
      return ([child.label, newChild.label], value)
    }

    return nil
  }

  guard let (path, value) = reflect(root) else {
    return nil
  }

  guard let (newPath, _) = reflect(`case`(value)) else {
    return nil
  }

  guard path == newPath else { return nil }

  return value
}
