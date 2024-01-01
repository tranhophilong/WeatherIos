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
    let searchResultCellViewModels = CurrentValueSubject<[SearchResulCellViewModel], Never>([])
    let showAlterView = CurrentValueSubject<Bool, Never>(false)
    let textSearching = CurrentValueSubject<String, Never>("")
    private var cancellabels = Set<AnyCancellable>()
    
    private func getPlaces(query: String){
        GMSPlacesClient.shared().findAutocompletePredictions(from: query)
            .sink {[weak self] completion in
                switch completion{
                case .finished:
                   break
                case .failure(_):
                    self!.searchResultCellViewModels.value = []
                    self!.showAlterView.value = true
                }
            } receiveValue: { [weak self] value in
                self!.showAlterView.value = false
                self?.searchResultCellViewModels.value = value.compactMap({ place in
                    let searchResultCellViewModel = SearchResulCellViewModel(place: place.attributedFullText.string, placeSearching: query)
                    return searchResultCellViewModel
                })
            }.store(in: &cancellabels)

    }
    
    func updateSearch(text: String){
        getPlaces(query: text)
    }
}

struct SearchResulCellViewModel{
    let place = PassthroughSubject<String, Never>()
    let placeSearching = PassthroughSubject<String, Never>()
    
    init(place: String, placeSearching: String){
        self.place.send(place)
        self.placeSearching.send(placeSearching)
    }
    
   
}
