//
//  UIImage + Extra.swift
//  Weather
//
//  Created by Long Tran on 09/11/2023.
//

import UIKit


extension UIImage {

    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

            let circleDiameter = max(size.width * 2, size.height * 2)
            let circleRadius = circleDiameter * 0.5
            let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
            let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
            let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

            let view = UIView(frame: circleFrame)
            view.backgroundColor = color ?? .systemRed
            view.layer.cornerRadius = 10.HAdapted

            UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

            let renderer = UIGraphicsImageRenderer(size: circleSize)
            let circleImage = renderer.image { ctx in
                view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
            }

            circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
            draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

            let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            return image
        }
    
   public func resizeImage1(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
