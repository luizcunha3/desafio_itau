//
//  GooglePlacesRepository.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

class GooglePlacesRepository {
    
    static func googleAddresToAddress(place: GMSPlace) -> Agencia? {
        return nil
    }
    
    func findItau(rangeInKilometers: Double, centerPosition: CLLocation, completion: @escaping ([Agencia]) -> Void) {
        let googlePlacesClient = GMSPlacesClient.shared()
        var openRequests = 0
        googlePlacesClient.autocompleteQuery(ConstantsHelper.GMS_PLACES_QUERY_STRING, bounds: nil, boundsMode: .restrict, filter: .none) { (preditcions, error) in
            if let itauAgencies = preditcions {
                for itauAgency in itauAgencies {
                    if let distanceFromUser = itauAgency.distanceMeters {
                        if distanceFromUser.doubleValue <= ConstantsHelper.RANGE_IN_KILOMETERS {
                            
                            googlePlacesClient.fetchPlace(fromPlaceID: itauAgency.placeID, placeFields: .all, sessionToken: nil) { (place, error) in
                                
                            }
                        }
                    }
                }
            } else {
                
            }
            
        }
    }
}
