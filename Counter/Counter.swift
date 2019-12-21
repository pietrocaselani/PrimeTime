import Architecture
import RxSwift
import PrimeModal

public enum CounterAction: Equatable {
  case decrTapped
  case incrTapped
  case isPrimeTapped
  case primeModalDismissed
  case nthPrimeButtonTapped
  case nthPrimeResponse(Result<Int, Error>)
  case nthPrimeAlertDismissed
}

public struct CounterState {
  public var count: Int
  public var isNthPrimeButtonDisabled: Bool
  public var primeModalShown: Bool
  public var primeAlert: PrimeAlert?

  public init(count: Int,
              isNthPrimeButtonDisabled: Bool,
              primeModalShown: Bool,
              primeAlert: PrimeAlert?) {
    self.count = count
    self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
    self.primeModalShown = primeModalShown
    self.primeAlert = primeAlert
  }
}

public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
  case .incrTapped:
    state.count += 1
  case .primeModalDismissed:
    state.primeModalShown = false
  case .isPrimeTapped:
    state.primeModalShown = true
  case .nthPrimeButtonTapped:
    state.isNthPrimeButtonDisabled = true
    return [
    Current.nthPrime(state.count)
      .map(Result<Int, Error>.success)
      .catchError { .just(Result.failure($0)) }
      .map(CounterAction.nthPrimeResponse)
      .eraseToEffect()
    ]
  case let .nthPrimeResponse(result):
    state.isNthPrimeButtonDisabled = false

    switch result {
    case let .success(value):
      state.primeAlert = PrimeAlert(prime: value)
    case let .failure(error):
      return [
        Effect.fireAndForget {
          print("Ignoring error: \(error)")
        }
      ]
    }
  case .nthPrimeAlertDismissed:
    state.primeAlert = nil
  }

  return []
}

public let counterViewReducer = combine(
  pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
  pullback(primeModalReducer, value: \CounterViewState.primeModal, action: \CounterViewAction.primeModal)
)

public func == (lhs: CounterAction, rhs: CounterAction) -> Bool {
  switch (lhs, rhs) {
  case (.decrTapped, .decrTapped): return true
  case (.incrTapped, .incrTapped): return true
  case (.isPrimeTapped, .isPrimeTapped): return true
  case (.primeModalDismissed, .primeModalDismissed): return true
  case (.nthPrimeButtonTapped, .nthPrimeButtonTapped): return true
  case let (.nthPrimeResponse(lhsResult), .nthPrimeResponse(rhsResult)):
    let lhsValue = try? lhsResult.get()
    let rhsValue = try? rhsResult.get()
    return lhsValue == rhsValue
  default: return false
  }
}
