import UIKit

extension Style where UIElement: UIView {
    static var rounded: Style {
        return Style { view in
            view.layer.cornerRadius = 5
        }
    }

    static var bordered: Style {
        return Style { view in
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.black.cgColor
        }
    }
}

extension Style where UIElement: UILabel {
    static var header: Style {
        return Style { label in
            label.font = UIFont.boldSystemFont(ofSize: 36)
            label.textColor = UIColor.red
        }
    }
}
