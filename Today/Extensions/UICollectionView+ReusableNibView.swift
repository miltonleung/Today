import UIKit

internal extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_: T.Type) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: T.defaultKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableNibView {
        register(T.nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_: T.Type) where T: ReusableNibView {
        register(T.nib, forSupplementaryViewOfKind: T.defaultKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: T.defaultKind,
            withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view of kind: \(T.defaultKind) with identifier: \(T.defaultReuseIdentifier)")
        }
        return view
    }

     func supplementaryView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard
            let view = supplementaryView(forElementKind: T.defaultKind,
                                         at: indexPath) as? T
            else {
                fatalError("Could not obtain supplementary view of kind: \(T.defaultKind)")
        }
        return view
    }
}
