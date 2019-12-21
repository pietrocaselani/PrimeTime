import Architecture

public struct CounterEnvironment {
  var nthPrime: (Int) -> Effect<Int>
}

extension CounterEnvironment {
  public static let live = CounterEnvironment(nthPrime: nthPrime(_:))
}

extension CounterEnvironment {
  static let mock = CounterEnvironment { _ in .sync { 17 } }
}

var Current = CounterEnvironment.live
