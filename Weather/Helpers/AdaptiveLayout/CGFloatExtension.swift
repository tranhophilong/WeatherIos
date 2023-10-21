//
//  CGFloatExtension.swift
//  AdaptiveLayoutUIKit
//
//  Created by Long Tran on 20/10/2023.
//

import UIKit

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}
