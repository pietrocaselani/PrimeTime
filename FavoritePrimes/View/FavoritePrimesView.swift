import Architecture
import SnapKit

public final class FavoritePrimesView: View {
  public let tableView = UITableView()

  public override func initialize() {
    addSubview(tableView)
  }

  public override func installConstraints() {
    tableView.snp.makeConstraints {
      $0.size.equalToSuperview()
    }
  }
}
