import Architecture
import Counter

struct AppState {
  var count: Int
  var favoritePrimes: [Int]
  var isPrimeModalShown: Bool
  var isNthPrimeButtonDisabled: Bool
  var alertNthPrime: PrimeAlert?

  static let initial = AppState(count: 0, favoritePrimes: [], isPrimeModalShown: false, isNthPrimeButtonDisabled: false, alertNthPrime: nil)

  var counterViewState: CounterViewState {
    get {
      CounterViewState(
        count: count,
        isPrimeModalShown: isPrimeModalShown,
        isNthPrimeButtonDisabled: isNthPrimeButtonDisabled,
        favoritePrimes: favoritePrimes,
        alertNthPrime: alertNthPrime
      )
    }
    set {
      count = newValue.count
      favoritePrimes = newValue.favoritePrimes
      isPrimeModalShown = newValue.isPrimeModalShown
      isNthPrimeButtonDisabled = newValue.isNthPrimeButtonDisabled
      alertNthPrime = newValue.alertNthPrime
    }
  }
}

enum AppAction {
  case counterView(CounterViewAction)

  var counterView: CounterViewAction? {
    get {
      guard case let .counterView(action) = self else { return nil }
      return action
    }
    set {
      guard case .counterView = self, let newValue = newValue else { return }
      self = .counterView(newValue)
    }
  }
}

let appReducer = logging(
  pullback(counterViewReducer, value: \AppState.counterViewState, action: \AppAction.counterView)
)
