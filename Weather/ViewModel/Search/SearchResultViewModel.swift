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
    let presentContentViewController = PassthroughSubject<ContentViewModel, Never>()
    private var cancellabels = Set<AnyCancellable>()
    
    private func getPlaces(query: String){
        GMSPlacesClient.shared().findAutocompletePredictions(from: query)
            .sink {[weak self] completion in
                switch completion{
                case .finished:
                   break
                case .failure(_):
                    self!.searchResultCellViewModels.value = []
                    self!.textSearching.value = query
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
    let place = CurrentValueSubject<String, Never>("")
    let placeSearching = CurrentValueSubject<String, Never>("")
    
    init(place: String, placeSearching: String){
        self.place.send(place)
        self.placeSearching.send(placeSearching)
    }
    
   
}
