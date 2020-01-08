import Architecture
import Combine

public struct CounterEnvironment {
  public var nthPrime: (Int) -> Effect<Int>
}

extension CounterEnvironment {
  public static let live = CounterEnvironment(nthPrime: nthPrime(_:))
}

#if DEBUG
extension CounterEnvironment {
  static let mock = CounterEnvironment.init { _ in
    Fail.init(error: NSError(domain: "domain", code: 1, userInfo: nil))
  }
}

public var Current = CounterEnvironment.live

#else

public let Current = CounterEnvironment.live
#endif
