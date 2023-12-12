//
//  String+Extra.swift
//  Weather
//
//  Created by Long Tran on 26/10/2023.
//

import UIKit


extension String{
    static func textSize(_ text: String?, withFont font: UIFont?) -> CGSize {
        guard let text = text, let font = font else {
            return CGSize.zero
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: attributes)
        return textSize
    }
    
   static func convertNextDate(dateString : String) -> String{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       let myDate = dateFormatter.date(from: dateString)!
       let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
       let somedateString = dateFormatter.string(from: tomorrow!)
       return somedateString
   }
    
    
    static func getYearMonthDay(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 0)
        let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
        
        return String(localTime[startIndex...endIndex])
    }
    
   
    
}
