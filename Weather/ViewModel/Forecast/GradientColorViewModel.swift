//
//  GradientColorViewModel.swift
//  Weather
//
//  Created by Long Tran on 15/12/2023.
//

import UIKit
import Combine

struct GradientColorViewModel: SubViewForecastViewModel{
    let isShowCurrentIndex = CurrentValueSubject<Bool, Never>(false)
    let gradientColors = PassthroughSubject<[CGColor], Never>()
    let gradientLocations = PassthroughSubject<[NSNumber], Never>()
    let frameGradientColorCA = PassthroughSubject<CGRect, Never>()
    let frameCurrentIndexCA = PassthroughSubject<CGRect, Never>()
    

    private let startPerGradientColors: CGFloat
    private let widthPerGradientColors: CGFloat
    private let startPerIndex: CGFloat
    private let _gradientColors: [CGColor]
    private let _gradientLocations: [NSNumber]
    
    init(isShowCurrentIndex: Bool, startPerGradientColors: CGFloat, widthPerGradientColors: CGFloat, startPerIndex: CGFloat, gradientColors: [UIColor], gradientLocations: [NSNumber]) {
        self.isShowCurrentIndex.value = isShowCurrentIndex
        self.startPerGradientColors = startPerGradientColors
        self.widthPerGradientColors = widthPerGradientColors
        self.startPerIndex = startPerIndex
        _gradientColors = gradientColors.map({ color in
            color.cgColor
        })
        _gradientLocations = gradientLocations
           
    }
    
    func getColorGradients(){
        gradientColors.send(_gradientColors)
    }
    
    func getGradientLocation(){
        gradientLocations.send(_gradientLocations)
    }
    
     func getFrameGradient(with widthGradientColor: CGFloat){
       let xGradientColorCA = widthGradientColor * startPerGradientColors
       let widthGradientColorCA = widthGradientColor * widthPerGradientColors
        
        frameGradientColorCA.send(CGRect(x: xGradientColorCA, y: 0, width: widthGradientColorCA, height: 5.VAdapted))
    }
    
     func getFrameCurrentIndexCA(with widthGradientColor: CGFloat) {
        let xCurrentIndexCA = widthGradientColor * startPerIndex
        
        frameCurrentIndexCA.send(CGRect(x: xCurrentIndexCA, y: 0, width: 5.VAdapted, height: 5.VAdapted))

    }
       
}


