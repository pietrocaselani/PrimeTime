import UIKit

open class ViewController<V: View>: UIViewController {
    public var typedView: V {
        guard let actualView = self.view as? V else {
            Swift.fatalError("self.view should be an instance of \(String(describing: V.self))")
        }
        return actualView
    }

    open override func loadView() {
        view = createView()
    }

    open func createView() -> V {
        return V()
    }
}
