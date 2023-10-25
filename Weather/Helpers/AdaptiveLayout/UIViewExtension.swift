//
//  UIViewExtension.swift
//  AdaptiveLayoutUIKit
//
//  Created by Long Tran on 20/10/2023.
//
import UIKit
import SnapKit

extension UIView {
    
    func addSeparator(width: CGFloat, x: CGFloat, y: CGFloat, to view: UIView) -> UIView{
        let separator = UIView(frame: .zero)
        addSubview(separator)
        separator.backgroundColor = .white.withAlphaComponent(1)
        separator.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(0.3)
            
            if x >= 0 && y >= 0 {
                make.left.equalTo(view).offset(x)
                make.top.equalTo(view).offset(y)
            }else{
                make.right.equalTo(view).offset(x)
                make.bottom.equalTo(view).offset(y)
            }
            
        }
        
        return separator
        
        
    }
}
