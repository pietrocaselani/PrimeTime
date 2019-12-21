import Architecture
import SnapKit

final class AppFlowView: View {
  lazy var counterButton = button(title: "Counter")
  lazy var favoritePrimesButton = button(title: "Favorites Primes")

  private lazy var rootStack = { () -> UIStackView in
    let view = UIStackView(arrangedSubviews: [self.counterButton, self.favoritePrimesButton])
    view.axis = .vertical
    return view
  }()

  override func initialize() {
    backgroundColor = .white
    addSubview(rootStack)
  }

  override func installConstraints() {
    rootStack.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
