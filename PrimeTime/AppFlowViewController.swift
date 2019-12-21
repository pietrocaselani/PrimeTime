import Architecture
import RxCocoa
import RxSwift

import Counter

final class AppFlowViewController: ViewController<AppFlowView> {
  private let disposeBag = DisposeBag()
  private let store: Store<AppState, AppAction>

  init(store: Store<AppState, AppAction>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    typedView.counterButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.goToCounter()
      }).disposed(by: disposeBag)
  }

  private func goToCounter() {
    let counterStore = store.view(
      value: { $0.counterViewState },
      action: { .counterView($0) }
    )

    let counterViewController = CounterViewController(store: counterStore)

    self.navigationController?.pushViewController(counterViewController, animated: true)
  }
}
