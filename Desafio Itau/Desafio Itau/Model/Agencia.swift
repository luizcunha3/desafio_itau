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
    var stringHorarioDeFuncionamento: String? {
        get {
            if let workingHours = self.horarioDeFuncionamento, let periods = workingHours.periods {
                var returnString = ""
                for period in periods {
                    returnString += "\(googleDayOfTheWeek(day: Int(period.openEvent.day.rawValue))) - \(period.openEvent.time.hour) - \(period.closeEvent!.time.hour)\n" 
                }
                 return returnString
            } else {
                return nil
            }
           
        }
    }
    
    private func googleDayOfTheWeek(day: Int) -> String {
        /**
         GMSDayOfWeekSunday = 1,
         GMSDayOfWeekMonday = 2,
         GMSDayOfWeekTuesday = 3,
         GMSDayOfWeekWednesday = 4,
         GMSDayOfWeekThursday = 5,
         GMSDayOfWeekFriday = 6,
         GMSDayOfWeekSaturday = 7,
         */
        switch day {
        case 2:
            return "Segunda-feira"
        case 3:
            return "Terça-feira"
        case 4:
            return "Quarta-feira"
        case 5:
            return "Quinta-feira"
        case 6:
            return "Sexta-Feira"
        case 7:
            return "Sábado"
        case 1:
            return "Domingo"
        default:
            return "erro"
        }
    }
    
}
