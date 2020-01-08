import Architecture
import RxSwift
import RxCocoa

public final class FavoritePrimesViewController: ViewController<FavoritePrimesView> {
  private let store: Store<FavoritePrimesState, FavoritePrimesAction>
  private let disposeBag = DisposeBag()

  public init(store: Store<FavoritePrimesState, FavoritePrimesAction>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    typedView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PrimeCell")

    subscribeToInputs()
    subscribeToOutputs()
  }

  private func subscribeToInputs() {
    store.value.favoritePrimes // ???

//    let primesObservable = store.value.map { $0.favoritePrimes }.asObservable()

//    primesObservable.bind(to: typedView.tableView.rx.items(cellIdentifier: "PrimeCell")) { (index, prime, cell) in
//      cell.textLabel?.text = "\(prime)"
//    }.disposed(by: disposeBag)
  }

  private func subscribeToOutputs() {
//    typedView.tableView.rx.itemDeleted
//      .map(FavoritePrimesAction.deleteFavoritePrimes)
//      .subscribe(onNext: store.send)
//      .disposed(by: disposeBag)
  }
}
