//
//  String+Extra.swift
//  Weather
//
//  Created by Long Tran on 26/10/2023.
//

import UIKit


extension String{
    static func textSize(_ text: String?, withFont font: UIFont?) -> CGSize {
        guard let text = text, let font = font else {
            return CGSize.zero
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: attributes)
        return textSize
    }

}
