import UIKit


/**
 A custom label that has some padding between its frame and its displayed text. Configurable in Interface Builder.
 */
@IBDesignable
class LabelWithPadding: UILabel {

    /** The padding (in points). Will be added to all edges. */
    @IBInspectable var padding: CGFloat = 8

    // Used twice, one in drawing and one in measuring
    private func paddedRectangle(_ original: CGRect) -> CGRect {
        return original.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: paddedRectangle(rect))
    }

    // Overriding textRect(forBounds:limitedToNumberOfLines:) so that
    // we measure the same rect we draw in, which is padded
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return super.textRect(forBounds: paddedRectangle(bounds), limitedToNumberOfLines: numberOfLines)
    }

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + padding * 2, height: originalSize.height + padding * 2)
    }
}
