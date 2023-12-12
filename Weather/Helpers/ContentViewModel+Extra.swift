//
//  ContentViewModel+Extra.swift
//  Weather
//
//  Created by Long Tran on 04/12/2023.
//

import UIKit

extension ContentViewModel{
    
    //   MARK: - Helper func
        
         func infoUVBar(uvIndex: Int) -> TempBarItem{
            let gradientColors: [UIColor] = [UIColor.green5, UIColor.green4, UIColor.green3, UIColor.yellow3, UIColor.yellow4, UIColor.yellow5, UIColor.orange4, UIColor.orange5, UIColor.red3, UIColor.red4, UIColor.red5, UIColor.purple]
            
            let gradientLocations = (0..<gradientColors.count).map {  NSNumber(value: Float($0) / Float(gradientColors.count - 1)) }
            let startPerUVBar = 0
            let widthPerUVBar = 1
            
            let xPerPointCurrentUV =  CGFloat(uvIndex) / CGFloat(gradientColors.count - 1)
            
            let uvBar = TempBarItem(isShowCurrentTemp: true, startPer: CGFloat(startPerUVBar), widthPer: CGFloat(widthPerUVBar), startPerPoint: CGFloat(xPerPointCurrentUV), gradientColors: gradientColors, gradientLocations: gradientLocations)
            return uvBar
        }
        
         func infoTempBar(minTempDay: Double, maxTempDay: Double, minTempTenDay: Double, maxTempTenDay: Double, currentTemp: Double, isShowCurrentTemp: Bool) -> TempBarItem{
           var gradientColors: [UIColor] = []
           
            let rangeTenDayTemp =  maxTempTenDay - minTempTenDay
            
            for temp in Int(minTempDay)...Int(maxTempDay){
                let colorTemp = converTempToColor(temp: CGFloat(temp))
                gradientColors.append(colorTemp)
            }
            
            gradientColors = gradientColors.reduce(into: [], { result, element in
                if !result.contains(element){
                    result.append(element)
                }
            })
             
            gradientColors.append(gradientColors.last!)
            let gradientLocations = (0..<gradientColors.count).map {  NSNumber(value: Float($0) / Float(gradientColors.count - 1)) }


            let startPerTempBar = 1 - ((maxTempTenDay - minTempDay) / rangeTenDayTemp)
           let widthPerTempBar = (maxTempDay - minTempDay) / rangeTenDayTemp
           let xPerPointCurrentTemp = 1 - ((maxTempTenDay - currentTemp) / rangeTenDayTemp)
    
            let tempBarItem = TempBarItem(isShowCurrentTemp: isShowCurrentTemp, startPer: CGFloat(startPerTempBar), widthPer: CGFloat(widthPerTempBar), startPerPoint: CGFloat(xPerPointCurrentTemp), gradientColors: gradientColors, gradientLocations: gradientLocations)
            return tempBarItem
        }
        
         func converTempToColor(temp: CGFloat) -> UIColor{
            if temp < -15{
                return .darkBlue1
            }
            else if temp < -10{
                return .darkBlue2
            }else if temp < -5{
                return .darkBlue3
            }
            else if temp < 0{
                return .lightBlue4
            }else if temp < 15{
                return .lightBlue3
            }
            else if  temp < 16{
                return .green5
            }else if temp < 17{
                return .green4
            }else if temp < 18{
                return .green3
            }else if temp < 19{
                return .green2
            }else if temp < 20{
                return .green1
            }
            else if  temp < 21{
                return .yellow1
            }else if temp < 22{
                return .yellow2
            }else if temp < 23{
                return .yellow3
            }else if temp < 24{
                return .yellow4
            }else if temp < 25{
                return .yellow5
            }else if temp < 26{
                return .orange1
            }else if temp < 27{
                return .orange2
            }else if temp < 28{
                return .orange3
            }else if temp < 29{
                return .orange4
            }
            else if  temp < 30{
                return .orange5
            }else if temp < 31{
                return .red4
            }else {
                return .red5
            }
        }
        
         func getLevelUV(of index: Int) -> String{
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
        
         func getWeekDay(of string: String) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: string) // Replace with your desired date
            if let unwrappedDate = date {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.weekday], from: unwrappedDate)
                if let weekday = components.weekday {
                    if weekday == 2{
                        return "Mon"
                    }else if weekday == 3{
                        return "Tue"
                    }else if weekday == 4{
                        return "Wed"
                    }else if weekday == 5{
                        return "Thu"
                    }else if weekday == 6{
                        return "Fri"
                    }else if  weekday == 7{
                        return "Sat"
                    }else {
                        return "Sun"
                    }
                }
            } else {
                return "Today"
            }
            return ""
        }
        
          func getNameIcon(of urlIcon: String, isday: Bool) -> String{
          let pattern = #"(\d+)\.png"#
          let nameIcon = matches(for: pattern, in: urlIcon)
            return isday ? nameIcon.replacingOccurrences(of: ".png", with: "") : nameIcon.replacingOccurrences(of: ".png", with: "N")
        }
        
       func matches(for regex: String, in text: String) -> String {
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text,
                                            range: NSRange(text.startIndex..., in: text))
                return results.map {
                    String(text[Range($0.range, in: text)!])
                }[0]
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return ""
            }
        }

        
        func getDay(in localTime: String) -> String{
           let startIndex = localTime.index(localTime.startIndex, offsetBy: 8)
           let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
           
           return String(localTime[startIndex...endIndex])
       }
       
        func getHour(in localTime: String) -> String{
           let startIndex = localTime.index(localTime.startIndex, offsetBy: 11)
           let endIndex = localTime.index(localTime.startIndex, offsetBy: 12)
           
           return String(localTime[startIndex...endIndex])
       }
       
         func getIndexAstro(in time: String) -> Int{
            
           let time24 = timeConversion24(time12: time)
            
            let startIndex = time24.index(time24.startIndex, offsetBy: 0)
            let endIndex = time24.index(time24.startIndex, offsetBy: 1)
            
            return Int(String(time24[startIndex...endIndex])) ?? 0
        }
        
    func getTime(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 11)
//        let endIndex = localTime.index(localTime.last, offsetBy: <#T##Int#>)
        
        return String(localTime[startIndex...])
    }
        
        func timeConversion24(time12: String) -> String {
            let dateAsString = time12
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"

            let date = df.date(from: dateAsString)
            df.dateFormat = "HH:mm"

            let time24 = df.string(from: date!)
            return time24
        }
}
