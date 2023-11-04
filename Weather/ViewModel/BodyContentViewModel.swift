//
//  BodyContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine


class BodyContentViewModel{
    
    
    func checkContentOffsetIsZero(contentOffset: CGFloat) -> Bool{
        if contentOffset <= 0 {
            return true
        }else{
            return false
        }
    }
}
