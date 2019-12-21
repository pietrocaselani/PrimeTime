import UIKit

open class View: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  public required init() {
    super.init(frame: CGRect.zero)
    setup()
  }

  open func initialize() {}

  open func installConstraints() {}

  private func setup() {
    initialize()
    installConstraints()
  }
}

public func button(title: String) -> UIButton {
  let view = UIButton(type: .custom)
  view.setTitle(title, for: .normal)
  view.setTitleColor(.black, for: .normal)
  return view
}
