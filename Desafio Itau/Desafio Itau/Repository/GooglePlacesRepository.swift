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
import MapKit

enum GooglePlacesRepositoryError: Error {
    case FatalError
}

protocol GooglePlacesRepositoryDelegate {
    func foundPlaces(places: [Agencia])
}

class GooglePlacesRepository: NSObject {
    
    var googlePlacesClient: GMSPlacesClient
    var token: GMSAutocompleteSessionToken
    var delegate: GooglePlacesRepositoryDelegate?
    
    override init() {
        self.googlePlacesClient = GMSPlacesClient.shared()
        self.token = GMSAutocompleteSessionToken.init()
    }
    
    func calcultateBounds(location: CLLocation) -> GMSCoordinateBounds {
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: ConstantsHelper.RANGE_IN_KILOMETERS, longitudinalMeters: ConstantsHelper.RANGE_IN_KILOMETERS)
        let northSouthToAdd = region.span.latitudeDelta / 2
        let eastWestToAdd = region.span.longitudeDelta / 2
        
        
        let northEastLatitude = location.coordinate.latitude + northSouthToAdd
        let northEastLongitude = location.coordinate.longitude + eastWestToAdd
        let northEastPosition = CLLocation(latitude: northEastLatitude, longitude: northEastLongitude)
        
        let southWestLatitude = location.coordinate.latitude - northSouthToAdd
        let southWestLongitude = location.coordinate.longitude - eastWestToAdd
        let southWestPosition = CLLocation(latitude: southWestLatitude, longitude: southWestLongitude)
        
        
        let bounds = GMSCoordinateBounds(coordinate: northEastPosition.coordinate, coordinate: southWestPosition.coordinate)
        return bounds
        
    }
    
    func googleAddresToAddress(place: GMSPlace) -> Agencia {
        let agency = Agencia()
        agency.nome = place.name
        agency.location = place.coordinate
        agency.endereco = place.formattedAddress
        agency.horarioDeFuncionamento = place.openingHours
        return agency
    }
    
    private func getGooglePlacesFromPredictions(predictions: [GMSAutocompletePrediction], completion: @escaping ([GMSPlace]) -> Void ) {
        var itauGooglePlaces: [GMSPlace] = []
        let group = DispatchGroup()
        for itauPrediction in predictions {
            group.enter()
            self.getGooglePlaceFromPrediction(placeId: itauPrediction.placeID) { (place) in
                itauGooglePlaces.append(place)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(itauGooglePlaces)
        }
        
        
    }
    
    private func getGooglePlaceFromPrediction(placeId: String, completion: @escaping (GMSPlace) -> Void) {
        self.googlePlacesClient.fetchPlace(fromPlaceID: placeId, placeFields: .all, sessionToken: nil) { (place, error) in
            if let itauPlace = place {
                completion(itauPlace)
            }
        }
    }
    
    
    func newGetPlaces(location: CLLocation) {
        let boundaries = self.calcultateBounds(location: location)
        let filter = GMSAutocompleteFilter()
        filter.origin = location
        let fetcher = GMSAutocompleteFetcher(bounds: boundaries, filter: filter)
        fetcher.delegate = self
        fetcher.provide(self.token)
        fetcher.sourceTextHasChanged(ConstantsHelper.GMS_PLACES_QUERY_STRING)
    }
}


extension GooglePlacesRepository: GMSAutocompleteFetcherDelegate {
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    self.getGooglePlacesFromPredictions(predictions: predictions) { (places) in
        var agencies: [Agencia] = []
        self.getGooglePlacesFromPredictions(predictions: predictions) { (places) in
            for place in places {
                agencies.append(self.googleAddresToAddress(place: place))
            }
            self.delegate!.foundPlaces(places: agencies)
        }
        
    }
  }

  func didFailAutocompleteWithError(_ error: Error) {
    print(error.localizedDescription)
  }
}
