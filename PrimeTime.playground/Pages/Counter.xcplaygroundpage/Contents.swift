import UIKit
import PlaygroundSupport

import Architecture

import Counter

let initialValue = CounterViewState(count: 0, isPrimeModalShown: false, favoritePrimes: [2, 3])

let store = Store(initialValue: initialValue, reducer: counterViewReducer)

//store.send(.counter(.decrTapped))

PlaygroundPage.current.liveView = CounterViewController(store: store)
