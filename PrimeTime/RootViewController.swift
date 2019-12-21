import UIKit

import Architecture
import PrimeModal
import Counter

import RxCocoa


func rootViewController() -> UIViewController {
  Logging.URLRequests = { _ in return false }
//  return primeModalViewController()
//  return counterViewController()

  return UINavigationController(rootViewController: appFlowViewController())
}

fileprivate func appFlowViewController() -> AppFlowViewController {
  let state = AppState.initial
  let store = Store(initialValue: state, reducer: appReducer)
  return AppFlowViewController(store: store)
}

fileprivate func primeModalViewController() -> PrimeModalViewController {
  let state = PrimeModalState(count: 13, favoritePrimes: [2, 3, 5])
  let store = Store(initialValue: state, reducer: primeModalReducer)
  return PrimeModalViewController(store: store)
}

fileprivate func counterViewController() -> CounterViewController {
  let state = CounterViewState(
    count: 0,
    isPrimeModalShown: false,
    isNthPrimeButtonDisabled: false,
    favoritePrimes: [],
    alertNthPrime: nil
  )
  let store = Store(initialValue: state, reducer: counterViewReducer)
  return CounterViewController(store: store)
}
