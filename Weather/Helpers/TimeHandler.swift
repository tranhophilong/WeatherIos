//
//  TimeConverter.swift
//  Weather
//
//  Created by Long Tran on 16/12/2023.
//

import Foundation


class TimeHandler{
    
    static func convertNextDate(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: date)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        return somedateString
    }
     
     
     static func getYearMonthDay(in time: String) -> String{
         let startIndex = time.index(time.startIndex, offsetBy: 0)
         let endIndex = time.index(time.startIndex, offsetBy: 9)
         
         return String(time[startIndex...endIndex])
     }
     
     static func getHour(in time: String) -> String{
         let startIndex = time.index(time.startIndex, offsetBy: 11)
         let endIndex = time.index(time.startIndex, offsetBy: 12)
         
         return String(time[startIndex...endIndex])
     }
     
     static func timeConversion24(time12: String) -> String {
         
         let dateAsString = time12
         let df = DateFormatter()
         df.dateFormat = "hh:mm a"
         let date = df.date(from: dateAsString)
         df.dateFormat = "HH:mm"
         let time24 = df.string(from: date!)
         
         return time24
     }
     
     static func getIndexAstro(in time: String) -> Int{
        
        let time24 = timeConversion24(time12: time)
        let startIndex = time24.index(time24.startIndex, offsetBy: 0)
        let endIndex = time24.index(time24.startIndex, offsetBy: 1)
         
        return Int(String(time24[startIndex...endIndex])) ?? 0
    }
    
    static func getWeekDay(of string: String) -> String{
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
     
  static func getDay(in localTime: String) -> String{
      let startIndex = localTime.index(localTime.startIndex, offsetBy: 8)
      let endIndex = localTime.index(localTime.startIndex, offsetBy: 9)
      
      return String(localTime[startIndex...endIndex])
  }
  
   static func getTime(in localTime: String) -> String{
        let startIndex = localTime.index(localTime.startIndex, offsetBy: 11)
        
        return String(localTime[startIndex...])
        
    }
}
