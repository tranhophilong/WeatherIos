//
//  ContentViewModel.swift
//  Weather
//
//  Created by Long Tran on 03/11/2023.
//

import UIKit
import Combine


enum BodyContentState{
     case refreshHeaderSubview
     case viewDidScroll
}

class ContentViewModel{
    
    let heightHeader = CurrentValueSubject<CGFloat, Never>(heightHeaderContent)
    private var didGetContentOffSetDidScroll: Bool = false
    private var contentOffSetDidScroll: CGFloat = 0
    let bodyContentState = PassthroughSubject<(BodyContentState, CGFloat), Never>()
    let changeLblHeader = PassthroughSubject<(Bool, CGFloat), Never>()
  
    
//    MARK: - Scroll Action
    func scrollAction(with contentOffset: CGFloat, bodyContentOffsetIsZero: Bool){
        let offset = -contentOffset - STATUS_BAR_HEIGHT()
        if heightHeaderContent + offset - 30.VAdapted >= heightHeaderContent/5 && bodyContentOffsetIsZero == true{
            heightHeader.value = heightHeaderContent + offset
            changeLblHeader.send((true, offset))
            if didGetContentOffSetDidScroll{
                bodyContentState.send((.refreshHeaderSubview, 0))
            }
            didGetContentOffSetDidScroll = false
        }else{
            changeLblHeader.send((false, 0))
            if !didGetContentOffSetDidScroll{
                didGetContentOffSetDidScroll = true
                contentOffSetDidScroll = contentOffset
            }
            bodyContentState.send((.viewDidScroll, contentOffSetDidScroll))
        }
    }
    
    
}
