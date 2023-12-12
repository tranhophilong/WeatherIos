//
//  UItableView+Extra.swift
//  Weather
//
//  Created by Long Tran on 06/12/2023.
//

import UIKit

extension UITableView {
    
    func ts_rectFromParent(at indexPath:IndexPath) -> CGRect {
        let rect = self.rectForRow(at: indexPath)
        return self.convert(rect, to: self.superview)
    }
}
