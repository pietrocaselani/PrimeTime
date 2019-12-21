import Architecture
import RxSwift
import RxCocoa

import PrimeModal

public final class CounterViewController: ViewController<CounterView> {
  private let disposeBag = DisposeBag()
  private let store: Store<CounterViewState, CounterViewAction>

  public init(store: Store<CounterViewState, CounterViewAction>) {
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
    typedView.decrButton.rx.tap
      .map { CounterViewAction.counter(.decrTapped) }
      .subscribe(onNext: store.send)
      .disposed(by: disposeBag)

    typedView.incButton.rx.tap
      .map { CounterViewAction.counter(.incrTapped) }
      .subscribe(onNext: store.send)
      .disposed(by: disposeBag)

    typedView.isPrimeButton.rx.tap
      .map { CounterViewAction.counter(.isPrimeTapped) }
      .subscribe(onNext: store.send)
      .disposed(by: disposeBag)

    typedView.nthPrimeButton.rx.tap
      .map { CounterViewAction.counter(.nthPrimeButtonTapped) }
      .subscribe(onNext: store.send)
      .disposed(by: disposeBag)
  }

  private func updateView(state: CounterViewState) {
    typedView.countLabel.text = "\(state.count)"
    typedView.nthPrimeButton.setTitle("What is the \(ordinal(state.count)) prime?", for: .normal)
    typedView.nthPrimeButton.isEnabled = !state.isNthPrimeButtonDisabled

    if state.isPrimeModalShown {
      guard presentedViewController == nil else { return }

      let primeModalStore = store.view(
        value: { PrimeModalState(count: $0.count, favoritePrimes: $0.favoritePrimes) },
        action: { .primeModal($0) }
      )

      let primeModalViewController = PrimeModalViewController(store: primeModalStore)
      primeModalViewController.presentationController?.delegate = self
      present(primeModalViewController, animated: true, completion: nil)
    } else if let alert = state.alertNthPrime {
      let alertController = UIAlertController(
        title: alert.title,
        message: alert.message,
        preferredStyle: .alert
      )

      alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [store] _ in
        store.send(.counter(.nthPrimeAlertDismissed))
      }))

      present(alertController, animated: true, completion: nil)
    }
  }
}

extension CounterViewController: UIAdaptivePresentationControllerDelegate {
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    if presentationController.presentedViewController is PrimeModalViewController {
      store.send(.counter(.primeModalDismissed))
    }
  }
}
