//
//  ProtocoloFechor.swift
//  Prueba
//
//  Created by Ayoze on 6/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation

class ProtocoloFechor {
    
    func protocoloFechor(datos:[UInt8])-> [UInt8]{
        var fechorDatos:[UInt8] = []
        var fechor = DevuelveFechor().devuelveBytesFechor()
        fechor.insert(62, at:0)
        fechorDatos = fechor + datos
        
        
        print ("fechorDatos", fechorDatos)
        return fechorDatos
        
    }
    
}
