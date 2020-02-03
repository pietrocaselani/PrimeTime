precedencegroup Composition {
    associativity: right
}
infix operator ..: Composition

public func ..<A, B, C> (
    lhs: CasePath<A, B>,
    rhs: CasePath<B, C>
) -> CasePath<A, C> {
    lhs.appending(path: rhs)
}

prefix operator ^
public prefix func ^ <Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in root[keyPath: kp] }
}

public prefix func ^<Root, Value>(
    path: CasePath<Root, Value>
) -> (Root) -> Value? {
    return path.extract
}

prefix operator /
public prefix func / <Root, Value> (
    case: @escaping (Value) -> Root
) -> CasePath<Root, Value> {
    CasePath(`case`)
}
