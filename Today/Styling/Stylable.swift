import UIKit

internal protocol Stylable: class {
    func apply(styles: Style<UIView>... )
}

extension Stylable where Self: UIView {
    func apply(styles: Style<Self>... ) {
        styles.forEach { $0.applyTo(self) }
    }
}

extension UIView: Stylable { }

internal struct Style<UIElement: Stylable> {
    fileprivate let applyTo: (UIElement) -> Void

    init(applyTo: @escaping ((UIElement) -> Void)) {
        self.applyTo = applyTo
    }
}
