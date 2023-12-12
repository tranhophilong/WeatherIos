//
//  SearchResultViewModel.swift
//  Weather
//
//  Created by Long Tran on 26/11/2023.
//

import Foundation
import Combine
import GooglePlaces

class SearchResultViewModel{
    let places = CurrentValueSubject<[String], Never>([])
    let showAlterView = CurrentValueSubject<Bool, Never>(false)
    private var cancellabels = Set<AnyCancellable>()
    
    func getPlaces(query: String){
        GMSPlacesClient.shared().findAutocompletePredictions(from: query)
            .sink {[weak self] completion in
                switch completion{
                case .finished:
                   break
                case .failure(_):
                    self!.places.value = []
                    self!.showAlterView.value = true
                }
            } receiveValue: { [weak self] value in
                self!.showAlterView.value = false
                self!.places.value = value.compactMap({ place in
                    place.attributedFullText.string
                })
            }.store(in: &cancellabels)

    }
}
