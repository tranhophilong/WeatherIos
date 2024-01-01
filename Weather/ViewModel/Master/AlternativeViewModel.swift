//
//  AlternativeViewModel.swift
//  Weather
//
//  Created by Long Tran on 26/12/2023.
//

import Foundation
import Combine

class AlternativeViewModel{
   let imageName = PassthroughSubject<String, Never>()
   let title = PassthroughSubject<String, Never>()
   let subTitle = CurrentValueSubject<String, Never>("")
    
    
    init(imgName: String, title: String){
        self.imageName.send(imgName)
        self.title.send(title)
    }

   func changeSubtitle(text: String){
        subTitle.value = text
        
    }
    
}
