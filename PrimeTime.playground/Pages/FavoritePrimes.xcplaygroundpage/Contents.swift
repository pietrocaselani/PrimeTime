import UIKit
import PlaygroundSupport

import Architecture
import FavoritePrimes

let state = FavoritePrimesState(favoritePrimes: [2, 3, 5])
let store = Store(initialValue: state, reducer: logging(favoritePrimesReducer))
PlaygroundPage.current.liveView = FavoritePrimesViewController(store: store)
