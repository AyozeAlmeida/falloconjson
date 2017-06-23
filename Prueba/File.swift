//
//  File.swift
//  Prueba
//
//  Created by Ayoze on 23/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation

protocol ComunicacionPeriferico {
    static var comando : [UInt8] { get set }
    var offSet : [UInt8] { get set }
    var datos : [UInt8] { get set }
    func fraccionDatagrama (datagrama : [UInt8]) -> [UInt8]
    
    
    
}
