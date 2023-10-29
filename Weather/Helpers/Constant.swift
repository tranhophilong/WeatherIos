//
//  Constant.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit

let heightHeaderContent: CGFloat = 350.VAdapted

func SCREEN_BOUNDS() -> CGRect {
    return UIScreen.main.bounds
}

func SCREEN_WIDTH() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func SCREEN_HEIGHT() -> CGFloat {
    return UIScreen.main.bounds.size.height
}


func SCREEN_MAX_LENGTH() -> CGFloat {
    return max(SCREEN_WIDTH(), SCREEN_HEIGHT())
}

func SCREEN_MIN_LENGTH() -> CGFloat {
    return min(SCREEN_WIDTH(), SCREEN_HEIGHT())
}

func STATUS_BAR_HEIGHT() -> CGFloat {
    var statusBarHeight: CGFloat = 0.0
    
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    
    return statusBarHeight
}
