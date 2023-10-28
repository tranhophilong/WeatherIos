//
//  Constant.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit

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
