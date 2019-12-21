import Architecture

public struct FavoritePrimesState {
  public var favoritePrimes: [Int]

  public init(favoritePrimes: [Int]) {
    self.favoritePrimes = favoritePrimes
  }
}

public enum FavoritePrimesAction {
  case deleteFavoritePrimes(IndexPath)
}

public func favoritePrimesReducer(state: inout FavoritePrimesState, action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexPath):
    state.favoritePrimes.remove(at: indexPath.row)
  }

  return []
}
