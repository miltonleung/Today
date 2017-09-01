import UIKit

internal struct Font {
    static func regular(size: CGFloat) -> UIFont { return Font.regular.font(with: size) }
    static func medium(size: CGFloat) -> UIFont { return Font.medium.font(with: size) }
    static func black(size: CGFloat) -> UIFont { return Font.black.font(with: size) }

    private enum Font: String, FontStyle {
        case regular = "Avenir"
        case medium = "Avenir-Medium"
        case black = "Avenir-Black"

        var name: String { return self.rawValue }
    }

}

private protocol FontStyle {
    var name: String { get }
}

extension FontStyle {
    func font(with size: CGFloat) -> UIFont {
        let fontName = name
        let fontSize = size
        let descriptor = UIFontDescriptor(name: fontName, size: fontSize)
        return UIFont(descriptor: descriptor, size: 0)
    }
}
