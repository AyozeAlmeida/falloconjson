//
//  BLEPresenter.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol SeleccionBalizaView: NSObjectProtocol {
    func setBalizas(balizas: [BalizaData])
    
}


class SeleccionBalizaPresenter {
   
    fileprivate let seleccionBalizaService: SeleccionBalizaService
    weak fileprivate var seleccionBalizaView : SeleccionBalizaView?
    fileprivate var escaneado : Escaneado
    fileprivate var firmado : Firmado
    var databaseManagement : DatabaseManagement
    
    init(seleccionBalizaService: SeleccionBalizaService, escaneado: Escaneado, firmado: Firmado) {
        self.seleccionBalizaService = seleccionBalizaService
        self.escaneado = escaneado
        self.firmado = firmado
        self.databaseManagement = DatabaseManagement()
    }
    
    func attachView(_ view: SeleccionBalizaView){
        self.seleccionBalizaView = view
    }
    
    func detachView() {
        self.seleccionBalizaView = nil
    }
    
    func obtenerBalizas() {
        self.seleccionBalizaService.obtenerBalizas(callback: { (balizas) in
            self.seleccionBalizaView?.setBalizas(balizas: balizas)
        })
    }
   
    func escan() {
        self.escaneado.inicializar(presenter: self)
    }
    func perifericoEncontrado(peripheral: CBPeripheral, manager: CBCentralManager)   {

       
        if databaseManagement.evalueBaliza(identificador:"3340CF08-2A4C-47F4-A360-3FA75561F7A2") {
            print("Es el que busco")
            self.firmado.inicializarFirmado(presenter: self, manager: manager, peripheral: peripheral)
            
        }
        else{
            print ("la baliza no es nuestra")
        }
        
    }
    
    func perifericoFirmado() {
        
        print ("has fichado a las 00:00:000")
        
        
    }
    
}
