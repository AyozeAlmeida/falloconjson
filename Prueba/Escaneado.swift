//
//  Escaneado.swift
//  Prueba
//
//  Created by Ayoze on 27/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import CoreBluetooth



class Escaneado: NSObject {
    
    var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    var presenter: SeleccionBalizaPresenter!

    func inicializar(presenter:SeleccionBalizaPresenter){
            self.presenter = presenter
        manager = CBCentralManager (delegate: self, queue:nil)
    }
    
      
}
extension Escaneado: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            central.scanForPeripherals(withServices: nil, options: nil)
            print ("habilitado")
            print(central.isScanning)
        }else{
            print (" no está habilitado.")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("lkaj")
        print (peripheral)
        
        //peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType(rawValue: 50)!)
        if peripheral.identifier.uuidString == "3340CF08-2A4C-47F4-A360-3FA75561F7A2"{
            //3340CF08-2A4C-47F4-A360-3FA75561F7A2
            //DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE
            
            print("Did discover peripheral", peripheral.identifier)
            
         
            self.manager.stopScan()
           self.presenter.perifericoEncontrado(peripheral: peripheral, manager: manager)
        }
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}
