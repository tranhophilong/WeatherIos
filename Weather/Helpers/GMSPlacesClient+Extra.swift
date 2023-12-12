//
//  GMSPlacesClient+Extra.swift
//  Weather
//
//  Created by Long Tran on 25/11/2023.
//

import Foundation
import GooglePlaces
import Combine

extension GMSPlacesClient{
    public func findAutocompletePredictions(from query: String, filter: GMSAutocompleteFilter? = nil, sessionToken: GMSAutocompleteSessionToken? = nil) -> Future<[GMSAutocompletePrediction], Error> {
            
            Future<[GMSAutocompletePrediction], Error> { promise in
                self.findAutocompletePredictions(
                    fromQuery: query,
                    filter: filter,
                    sessionToken: sessionToken
                ) { predictions, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let predictions = predictions {
                        promise(.success(predictions))
                    }
                }
            }
        }
    
    public func findPlaceLikelihoodsFromCurrentLocation(fields: GMSPlaceField) -> Future<[GMSPlaceLikelihood], Error> {
            Future<[GMSPlaceLikelihood], Error> { promise in
                self.findPlaceLikelihoodsFromCurrentLocation(
                    withPlaceFields: fields
                ) { placeLikelihoods, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let placeLikelihoods = placeLikelihoods {
                        promise(.success(placeLikelihoods))
                    }
                }
            }
        }
}
