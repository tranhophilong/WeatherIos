//
//  Font.swift
//  AdaptiveLayoutUIKit
//
//  Created by Родион on 11.07.2020.
//  Copyright © 2020 Rodion Artyukhin. All rights reserved.
//

import UIKit

enum AdaptiveFont{
    static func regular(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size.adaptedFontSize, weight: .regular)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size.adaptedFontSize, weight: .medium)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size.adaptedFontSize, weight: .bold)
    }
    
    static func thin(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size.adaptedFontSize, weight: .thin)
    }
    
}
  

