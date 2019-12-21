import Architecture
import SnapKit

final class AppFlowView: View {
  lazy var counterButton = button(title: "Counter")

  override func initialize() {
    backgroundColor = .white
    addSubview(counterButton)
  }

  override func installConstraints() {
    counterButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
