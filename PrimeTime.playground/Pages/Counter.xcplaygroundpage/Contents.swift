import UIKit
import PlaygroundSupport

import Architecture
import Counter

let initialValue = CounterViewState(count: 0,
                                    isPrimeModalShown: false,
                                    isNthPrimeButtonDisabled: false,
                                    favoritePrimes: [2, 3, 5],
                                    alertNthPrime: nil)

let store = Store(initialValue: initialValue, reducer: counterViewReducer)

//store.send(.counter(.decrTapped))

//Current.nthPrime = { _ in
//    Effect.just(42).eraseToEffect()
//}

PlaygroundPage.current.liveView = CounterViewController(store: store)
