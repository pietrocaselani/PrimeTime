import UIKit
import PlaygroundSupport

import Architecture
import PrimeModal

let initialValue = PrimeModalState(count: 13, favoritePrimes: [2, 3, 5])
let store = Store(initialValue: initialValue, reducer: primeModalReducer)

PlaygroundPage.current.liveView = PrimeModalViewController(store: store)
