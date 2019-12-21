import Architecture
import SnapKit

public final class CounterView: View {
  lazy var countLabel = { () -> UILabel in
    let view = UILabel()
    view.textAlignment = .center
    return view
  }()

  lazy var incButton = button(title: "+")
  lazy var decrButton = button(title: "-")

  lazy var isPrimeButton = button(title: "Is prime?")
  lazy var nthPrimeButton = button(title: "")

  private lazy var counterStack = { () -> UIStackView in
    let view = UIStackView(arrangedSubviews: [self.decrButton, self.countLabel, self.incButton])
    view.axis = .horizontal
    view.distribution = .fillProportionally
    return view
  }()

  private lazy var rootStack = { () -> UIStackView in
    let view = UIStackView(arrangedSubviews: [self.counterStack, self.isPrimeButton, self.nthPrimeButton])
    view.axis = .vertical
    return view
  }()

  public override func initialize() {
    backgroundColor = .white
    addSubview(rootStack)
  }

  public override func installConstraints() {
    rootStack.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
