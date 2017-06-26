//
//  BLEPresenter.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation


struct BLEData{
    let pregunta: String
    let respuesta: String
}
protocol getDataBLE: NSObjectProtocol{
    func setDatos()
}
/*class BLEPresenter {
    fileprivate let bleService: BalizaWebService
    weak fileprivate var bleView: ViewController?
    init (bleService: BLEService){
        self.bleService = bleService
    }
}*/
