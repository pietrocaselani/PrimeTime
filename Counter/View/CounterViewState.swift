import PrimeModal

public struct CounterViewState {
  public var count: Int
  public var favoritePrimes: [Int]
  public var isPrimeModalShown: Bool
  public var isNthPrimeButtonDisabled: Bool
  public var alertNthPrime: PrimeAlert?

  public static let initial = CounterViewState(count: 0, isPrimeModalShown: false,
                                               isNthPrimeButtonDisabled: false, favoritePrimes: [], alertNthPrime: nil)

  public init(count: Int,
              isPrimeModalShown: Bool,
              isNthPrimeButtonDisabled: Bool,
              favoritePrimes: [Int],
              alertNthPrime: PrimeAlert?) {
    self.count = count
    self.isPrimeModalShown = isPrimeModalShown
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
    self.alertNthPrime = alertNthPrime
  }

  public var counter: CounterState {
    get {
      CounterState(
        count: count,
        isNthPrimeButtonDisabled: isNthPrimeButtonDisabled,
        primeModalShown: isPrimeModalShown,
        primeAlert: alertNthPrime)
    }
    set {
      self.count = newValue.count
      self.isPrimeModalShown = newValue.primeModalShown
      self.isNthPrimeButtonDisabled = newValue.isNthPrimeButtonDisabled
      self.alertNthPrime = newValue.primeAlert
    }
  }

  public var primeModal: PrimeModalState {
    get { PrimeModalState(count: count, favoritePrimes: favoritePrimes) }
    set {
      self.count = newValue.count
      self.favoritePrimes = newValue.favoritePrimes
    }
  }
}
