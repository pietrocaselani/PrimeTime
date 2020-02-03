import Architecture
import Counter
import FavoritePrimes

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

  var favoritePrimesState: FavoritePrimesState {
    get { FavoritePrimesState(favoritePrimes: favoritePrimes) }
    set { favoritePrimes = newValue.favoritePrimes }
  }
}

enum AppAction {
  case counterView(CounterViewAction)
  case favoritePrimes(FavoritePrimesAction)

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

  var favoritePrimes: FavoritePrimesAction? {
    get {
      guard case let .favoritePrimes(action) = self else { return nil }
      return action
    }
    set {
      guard case .favoritePrimes = self, let newValue = newValue else { return }
      self = .favoritePrimes(newValue)
    }
  }
}

let appReducer = logging(
  combine(
    pullback(counterViewReducer, value: \AppState.counterViewState, action: /AppAction.counterView),
    pullback(favoritePrimesReducer, value: \AppState.favoritePrimesState, action: /AppAction.favoritePrimes)
  )
)
