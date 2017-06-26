//
//  ProtocoloBalizaComunicacion.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
protocol ComunicacionBaliza {
    var comando:[Int8] {get set}
    var fechorUTC:[Int8] {get set}
    var Mesaje:[Int8] {get set}
    func particionaDatagrama()
}
