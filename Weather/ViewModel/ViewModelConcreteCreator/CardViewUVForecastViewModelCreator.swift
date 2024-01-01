//
//  CardViewUVForecastViewModelCreator.swift
//  Weather
//
//  Created by Long Tran on 22/12/2023.
//

import UIKit


class CardViewUVForecastViewModelCreator: CardViewCurrentForecastViewModelCreator{
    
    
    var currentWeather: CurrentWeather
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
   
    
    func createCardViewModel() -> CardViewModel {
        let forecastViewModel = createForecastViewModel()
       return CardViewModel(title: "UV INDEX", icon: UIImage(systemName: "sun.max.fill")!, contentCardViewModel: forecastViewModel)
    }
    
    func createForecastViewModel() -> ForecastViewModel {
        
        let uvIndex = Int(currentWeather.uv)
        let levelUv = getLevelUV(of: uvIndex)
        let subViewForecastViewModel = createSubViewForecastViewModel()
        
        return ForecastViewModel(index: String(uvIndex), subDescription: levelUv, subDescriptionViewModel: subViewForecastViewModel)
    }
    
    private func getLevelUV(of index: Int) -> String{
        
        var level = ""
        if index >= 0 && index < 3{
            level = "Low"
        }else if index < 6{
            level = "Moderate"
        }else if index < 8{
            level = "High"
        }else if index < 11{
            level = "Very high"
        }else{
            level = "Extreme violet"
        }
        
        return level
        
    }
    
    func createSubViewForecastViewModel() -> SubViewForecastViewModel {
        infoUVBar(uvIndex: Int(currentWeather.uv))
    }
    
    private func infoUVBar(uvIndex: Int) -> SubViewForecastViewModel{
        let gradientColors: [UIColor] = [UIColor.green5, UIColor.green4, UIColor.green3, UIColor.yellow3, UIColor.yellow4, UIColor.yellow5, UIColor.orange4, UIColor.orange5, UIColor.red3, UIColor.red4, UIColor.red5, UIColor.purple]
        
        let gradientLocations = (0..<gradientColors.count).map {  NSNumber(value: Float($0) / Float(gradientColors.count - 1)) }
        let startPerUVBar = 0
        let widthPerUVBar = 1
        
        let xPerPointCurrentUV =  CGFloat(uvIndex) / CGFloat(gradientColors.count - 1)
        
        let uvBarViewModel = GradientColorViewModel(isShowCurrentIndex: true, startPerGradientColors: CGFloat(startPerUVBar), widthPerGradientColors: CGFloat(widthPerUVBar), startPerIndex: xPerPointCurrentUV, gradientColors: gradientColors, gradientLocations: gradientLocations)
        return uvBarViewModel
    }
    
    
}
