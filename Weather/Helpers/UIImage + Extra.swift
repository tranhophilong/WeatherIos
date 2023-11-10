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
}
