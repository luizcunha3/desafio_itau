//
//  AgenciasViewModel.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class AgenciaViewModel {
    
    var delegate: AgenciaViewDelegate!
    
    private let agencias: [Agencia] = []
    
    private let repository = GooglePlacesRepository()
    
    init() {
        self.repository.delegate = self
    }
    
    func ready(location: CLLocation?) {
        delegate.setLoadingTo(true)
        if let userLocation = location {
            repository.newGetPlaces(location: userLocation)
        }
        
    }
}

extension AgenciaViewModel: GooglePlacesRepositoryDelegate {
    func foundPlaces(places: [Agencia]) {
        self.delegate.showAgencias(agencias: places)
    }
}
