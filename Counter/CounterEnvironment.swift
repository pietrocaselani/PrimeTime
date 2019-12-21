import Architecture

public struct CounterEnvironment {
  var nthPrime: (Int) -> Effect<Int>
}

extension CounterEnvironment {
  public static let live = CounterEnvironment(nthPrime: nthPrime(_:))
}

#if DEBUG
extension CounterEnvironment {
  static let mock = CounterEnvironment.init { _ in
    return Effect.error(NSError.init(domain: "domain", code: 1, userInfo: nil)).eraseToEffect()
  }
}
#endif

var Current = CounterEnvironment.live
