//
//  FitUILabel.swift
//  Weather
//
//  Created by Long Tran on 27/10/2023.
//

import UIKit

// An UILabel subclass allowing you to automatize the process of adjusting the font size.
@IBDesignable
open class FittableFontLabel: UILabel {

    // MARK: Properties

    /// If true, the font size will be adjusted each time that the text or the frame change.
    @IBInspectable public var autoAdjustFontSize: Bool = true

    /// The biggest font size to use during drawing. The default value is the current font size
    @IBInspectable public var maxFontSize: CGFloat = CGFloat.nan

    /// The scale factor that determines the smallest font size to use during drawing. The default value is 0.1
    @IBInspectable public var minFontScale: CGFloat = CGFloat.nan

    /// UIEdgeInset
    @IBInspectable public var leftInset: CGFloat = 0
    @IBInspectable public var rightInset: CGFloat = 0
    @IBInspectable public var topInset: CGFloat = 0
    @IBInspectable public var bottomInset: CGFloat = 0
    
    /// Identifier
    @IBInspectable public var linkIdentifier: String?

    // MARK: Properties override

    open override var text: String? {
        didSet {
            adjustFontSize()
        }
    }

    open override var frame: CGRect {
        didSet {
            adjustFontSize()
        }
    }

    // MARK: Private

    var isUpdatingFromIB = false

    // MARK: Life cycle

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        isUpdatingFromIB = autoAdjustFontSize
        adjustFontSize()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        isUpdatingFromIB = autoAdjustFontSize
        adjustFontSize()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if !isUpdatingFromIB {
            adjustFontSize()
        }
        isUpdatingFromIB = false
    }

    // MARK: Insets

    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

}

// MARK: Helpers

extension FittableFontLabel {

    private func adjustFontSize() {
        if autoAdjustFontSize {
            fontSizeToFit(maxFontSize: maxFontSize, minFontScale: minFontScale)
        }
    }
}
