//
//  UIView+Extra.swift
//  Weather
//
//  Created by Long Tran on 06/12/2023.
//

import UIKit


extension UIView{
    
    func ts_toImage(opaque: Bool = true) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        
        let image = renderer.image { rendererContext in
            let context = rendererContext.cgContext
            
            if !opaque {
                context.clear(rendererContext.format.bounds)
            }
            
            self.layer.render(in: context)
        }
        
        return image
    }
}
