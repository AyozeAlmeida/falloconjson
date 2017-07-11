//
//  Baliza2.swift
//  Prueba
//
//  Created by Ayoze on 10/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
class Baliza2: CustomStringConvertible {
    let id: Int64?
    let idBaliza: Int64?
    let idMaquina :Int64?
    let idMaquinaLogica :Int64?
    let nombre :String
    let idGmAntes :Int64?
    let idGmDentro :Int64?
    let idGmDespues :Int64?
    let fechorDesde : Int64?
    let fechorHasta : Int64?
    let idGmIdAntes :Int64?
    let idGmIdDespues :Int64?
    let idGmIdDentro :Int64?
    
    init(id: Int64, idBaliza: Int64, idMaquina: Int64, idMaquinaLogica: Int64, nombre: String, idGmAntes: Int64, idGmDentro: Int64, idGmDespues: Int64, fechorDesde: Int64, fechorHasta: Int64, idGmIdAntes: Int64, idGmIdDespues: Int64, idGmIdDentro: Int64 ) {
        self.id = id
        self.idBaliza = idBaliza
        self.idMaquina = idMaquina
        self.idMaquinaLogica = idMaquinaLogica
        self.nombre = nombre
        self.idGmAntes = idGmAntes
        self.idGmDentro = idGmDentro
        self.idGmDespues = idGmDespues
        self.fechorDesde = fechorDesde
        self.fechorHasta = fechorHasta
        self.idGmIdAntes = idGmIdAntes
        self.idGmIdDespues = idGmIdDespues
        self.idGmIdDentro = idGmIdDentro
    }
    var description: String {
        return "id = \(self.id ?? 0), idmaquina = \(String(describing: self.idMaquina)), idMaquinalogico = \(String(describing: self.idMaquinaLogica))"
    }
}
