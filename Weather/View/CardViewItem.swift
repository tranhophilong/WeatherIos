//
//  CardViewItem.swift
//  Weather
//
//  Created by Long Tran on 30/10/2023.
//

import UIKit

struct CardViewItem{
    let title: String
    let icon: UIImage?
    let content: ViewForCardView
    let widthSeparator: CGFloat
    let titleColor: UIColor
    let iconColor: UIColor
    let heightHeader: Int
    
}

class ViewForCardView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
