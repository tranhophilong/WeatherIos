//
//  IntExtension.swift
//  Weather
//
//  Created by Long Tran on 21/10/2023.
//

import Foundation

import UIKit

extension Int {
    var VAdapted: CGFloat {
        adapted(dimensionSize: CGFloat(self), to: .height)
    }
    
    var HAdapted: CGFloat {
        adapted(dimensionSize: CGFloat(self), to: .width)
    }
}
