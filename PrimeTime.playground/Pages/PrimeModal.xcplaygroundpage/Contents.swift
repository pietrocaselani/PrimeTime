import UIKit
import PlaygroundSupport

import Architecture
import RxSwift
import RxCocoa

import PrimeModal

let initialValue = PrimeModalState(count: 13, favoritePrimes: [2, 3, 5])

let store = Store(initialValue: initialValue, reducer: logging(primeModalReducer))

//store.send(.counter(.decrTapped))

PlaygroundPage.current.liveView = PrimeModalViewController(store: store)
