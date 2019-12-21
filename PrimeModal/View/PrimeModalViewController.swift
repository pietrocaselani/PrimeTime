import Architecture
import RxSwift

public final class PrimeModalViewController: ViewController<PrimeModalView> {
  private typealias S = PrimeModalViewController
  private let store: Store<PrimeModalState, PrimeModalAction>
  private let disposeBag = DisposeBag()

  public init(store: Store<PrimeModalState, PrimeModalAction>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    subscribeToInputs()
    subscribeToOutputs()
  }

  private func subscribeToInputs() {
    store.value.drive(onNext: updateView(state:)).disposed(by: disposeBag)
  }

  private func subscribeToOutputs() {
    let buttonObservable = typedView.saveOrRemoveButton.rx.tap.asObservable()
    let stateObservable = store.value.asObservable()

    Observable.zip(buttonObservable, stateObservable)
      .map { S.mapStateToAction($0.1) }
      .subscribe(onNext: store.send).disposed(by: disposeBag)
  }

  private func updateView(state: PrimeModalState) {
    if S.isPrime(p: state.count) {
      typedView.isPrimeLabel.text = "\(state.count) is prime 🎉"
      typedView.saveOrRemoveButton.setTitle(S.saveOrRemoveButtonTitle(state), for: .normal)
      typedView.saveOrRemoveButton.isHidden = false
    } else {
      typedView.isPrimeLabel.text = "\(state.count) is not prime :("
      typedView.saveOrRemoveButton.setTitle("", for: .normal)
      typedView.saveOrRemoveButton.isHidden = true
    }
  }

  private static func saveOrRemoveButtonTitle(_ state: PrimeModalState) -> String {
    return isFavoritePrime(state) ? "Remove from favorite primes" : "Save to favorite primes"
  }

  private static func isFavoritePrime(_ state: PrimeModalState) -> Bool {
    return state.favoritePrimes.contains(state.count)
  }

  private static func mapStateToAction(_ state: PrimeModalState) -> PrimeModalAction {
    return isFavoritePrime(state) ? PrimeModalAction.removeFavoritePrimeTapped : PrimeModalAction.saveFavoritePrimeTapped
  }

  private static func isPrime(p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
      if p % i == 0 { return false }
    }
    return true
  }
}
