//
//  Constant.swift
//  Weather
//
//  Created by Long Tran on 22/10/2023.
//

import UIKit

let heightHeaderContent: CGFloat = 350.VAdapted
let disConditionLblAndDegreeLbl: CGFloat = round(heightHeaderContent * 0.027)
let disHightLowDegreeLblAndConditionWeatherLbl: CGFloat = round(heightHeaderContent * 0.027)
let didsDegreeLblAndLocationLbl: CGFloat = round(heightHeaderContent * 0.027)

let disLocationLblAndTopHeaderStart: CGFloat = heightHeaderContent/5
let disDegreeLblAndBottomHeader: CGFloat = heightHeaderContent * 2/5
let disConditionWeatherLblAndBottomHeader: CGFloat = round(heightHeaderContent * 0.3)
let disDegreeConditionAndBottomHeader: CGFloat = round(heightHeaderContent * 0.627)
let disHightLowDegreeLblAndBottomHeader: CGFloat = heightHeaderContent/5

let heightHightAndLowDegreeLbl: CGFloat = round(heightHeaderContent * 0.073)
let heightConditionLbl: CGFloat = round(heightHeaderContent * 0.073)
let heightDegreeLbl: CGFloat = heightHeaderContent/5

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
