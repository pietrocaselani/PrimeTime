import RxSwift

public struct Effect<Element>: ObservableType {
  private let observable: Observable<Element>

  public init(_ observable: Observable<Element>) {
    self.observable = observable
  }

  public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Effect.Element == Observer.Element {
    return observable.subscribe(observer)
  }
}

extension Effect {
  public static func fireAndForget(work: @escaping () -> Void) -> Effect {
    return Observable<Element>.deferred { () -> Observable<Element> in
      work()
      return Observable.empty()
    }.eraseToEffect()
  }

  public static func sync(work: @escaping () -> Element) -> Effect {
    return Observable.deferred {
      Observable.just(work())
    }.eraseToEffect()
  }
}

extension ObservableType {
  public func eraseToEffect() -> Effect<Element> {
    return Effect(self.asObservable())
  }
}
