import RxSwift
import RxRelay
import RxCocoa

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public final class Store<Value, Action> {
  private let reducer: Reducer<Value, Action>
  private let valueSubject: BehaviorRelay<Value>

  private var viewDisposable: Disposable?
  private var effectDisposables = [Disposable]()

  private let disposeBag = DisposeBag()

  public lazy var value = self.valueSubject.asDriver()

  public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
    self.valueSubject = BehaviorRelay(value: initialValue)
    self.reducer = reducer
  }

  public func send(_ action: Action) {
    var value = valueSubject.value
    let effects = self.reducer(&value, action)

    valueSubject.accept(value)

    effects.forEach { effect in
      effect.subscribe(onNext: self.send).disposed(by: disposeBag)
    }
  }

  public func view<LocalValue, LocalAction>(
    value toLocalValue: @escaping (Value) -> LocalValue,
    action toGlobalAction: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let localStore = Store<LocalValue, LocalAction>(
      initialValue: toLocalValue(self.valueSubject.value),
      reducer: { localValue, localAction in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.valueSubject.value)
        return []
    }
    )

    localStore.viewDisposable = self.valueSubject.subscribe(onNext: { [weak localStore] newValue in
      localStore?.valueSubject.accept(toLocalValue(newValue))
    })

    return localStore
  }
}

public func combine<Value, Action>(
  _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
  return { value, action in
    return reducers.flatMap { $0(&value, action) }
  }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
  _ reducer: @escaping Reducer<LocalValue, LocalAction>,
  value: WritableKeyPath<GlobalValue, LocalValue>,
  action: CasePath<GlobalAction, LocalAction>
) -> Reducer<GlobalValue, GlobalAction> {
  return { globalValue, globalAction in
    guard let localAction = action.extract(globalAction) else { return [] }
    let localEffects = reducer(&globalValue[keyPath: value], localAction)

    return localEffects.map { localEffect in
      localEffect.map(action.embed).eraseToEffect()
    }
  }
}

public func logging<Value, Action>(
  _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducer(&value, action)
    let newValue = value
    return [.fireAndForget {
      print("Action: \(action)")
      print("Value:")
      dump(newValue)
      print("---")
      }] + effects
  }
}
