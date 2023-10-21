//
//  UIViewExtension.swift
//  AdaptiveLayoutUIKit
//
//  Created by Long Tran on 20/10/2023.
//
import UIKit

extension UIView {
    func updateAdaptedConstraints() {
        
        let adaptedConstraints = constraints.filter { (constraint) -> Bool in
            return constraint is AdaptedConstraint
        } as! [AdaptedConstraint]
        
        for constraint in adaptedConstraints {
            constraint.resetConstant()
            constraint.awakeFromNib()
        }
    }
}
