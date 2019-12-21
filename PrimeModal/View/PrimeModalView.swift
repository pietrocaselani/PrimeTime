import Architecture
import SnapKit

public final class PrimeModalView: View {
  lazy var isPrimeLabel = { () -> UILabel in
    let view = UILabel()
    view.textAlignment = .center
    return view
  }()

  lazy var saveOrRemoveButton = button(title: "")

  private lazy var rootStack = { () -> UIStackView in
    let view = UIStackView(arrangedSubviews: [self.isPrimeLabel, self.saveOrRemoveButton])
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
