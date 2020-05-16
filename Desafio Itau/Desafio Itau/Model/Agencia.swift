//
//  Agencia.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

class Agencia {
    var location: CLLocationCoordinate2D?
    var nome: String?
    var endereco: String?
    var horarioDeFuncionamento: GMSOpeningHours?
}
