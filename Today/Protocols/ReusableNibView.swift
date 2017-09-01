import UIKit

internal protocol ReusableNibView: NibLoadable, ReusableView { }

internal protocol NibLoadable: class {
    static var nib: UINib { get }
}

internal extension NibLoadable {
    private static var nibName: String {
        return String(describing: self)
    }

    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}

internal protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
    static var defaultKind: String { get }
}

internal extension ReusableView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }

    static var defaultKind: String {
        return String(describing: self) + "Kind"
    }
}
