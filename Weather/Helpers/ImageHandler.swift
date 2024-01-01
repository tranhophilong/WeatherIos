//
//  NameImgHandler.swift
//  Weather
//
//  Created by Long Tran on 16/12/2023.
//

import Foundation


class ImageHandler{
    
    static func getNameIcon(of urlIcon: String, isday: Bool) -> String{
        
        let pattern = #"(\d+)\.png"#
        var nameIcon = ""
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: urlIcon,
                                        range: NSRange(urlIcon.startIndex..., in: urlIcon))
            nameIcon = results.map {
                String(urlIcon[Range($0.range, in: urlIcon)!])
            }[0]
        } catch let error {
            return ""
        }
        
        return isday ? nameIcon.replacingOccurrences(of: ".png", with: "") : nameIcon.replacingOccurrences(of: ".png", with: "N")
        
    }
}
