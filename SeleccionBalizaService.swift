//
//  SeleccionBalizaService.swift
//  
//
//  Created by Ayoze on 6/7/17.
//
//


import Foundation
import CoreBluetooth
import UIKit


class SeleccionBalizaService: NSObject {
    var balizas: [BalizaData] = []
    var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    let identifier = "3340CF08-2A4C-47F4-A360-3FA75561F7A2"
    //var characteristic: CBCharacteristic!
    var dataStringAnterior : String = ""
    var splitDatagramaEscritura: [[UInt8]] = []
    var splitDatagramaLectura: [[UInt8]] = []
    var i = 0
    
    
    func obtenerBalizas(callback:@escaping ([BalizaData]) -> ()) -> Void {
        // manager = CBCentralManager (delegate: self, queue: nil)
        // Central Manager
        //Escaneado().escaneaBaliza(callback: {(manager) in print ("vamos",manager)})
        balizas = [BalizaData(uuid: "3340CF08-2A4C-47F4-A360-3FA75561F7A2") , BalizaData(uuid: "33550CF08-2A4C-47F4-A360-3FA75561F7A2") ]
        
        //print("este es el uptime ",self.systemUptime())
        // print("UTC",Date().currentUTCTimeZoneDate)
        //DatabaseManagement().queryAllProduct()
        callback(balizas)
    }
    
    
}
