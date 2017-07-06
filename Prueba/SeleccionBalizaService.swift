//
//  BLEService.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
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
/*extension SeleccionBalizaService: BalizaEncontrada{
    func balizaEncontrada(callback:@escaping (String) -> ()) -> Void {
        //consulta en la base de datos si existe el device
        let confirmacion : String
        if identifier == self.identifier{
         confirmacion = "ok"
        }else{
           confirmacion = "cancel"
        }
        callback(confirmacion)
        
    }
    
}*/
/*extension SeleccionBalizaService: CBCentralManagerDelegate {
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

        peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType(rawValue: 50)!)
        if peripheral.identifier.uuidString == "DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE"{
            //3340CF08-2A4C-47F4-A360-3FA75561F7A2
            //DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE
            //
            print("Did discover peripheral", peripheral.identifier)
            
            //self.balizaEncontrada(callback: <#T##(String) -> ()#>)(callback: { (balizas) in
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            manager.connect(peripheral, options: nil)
        }
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}


extension SeleccionBalizaService: CBPeripheralDelegate {
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            print ("este es el servicio",thisService.uuid.uuidString)
            if service.uuid.uuidString == "0000F00D-1212-EFDE-1523-785FEF13D123" {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        print("Looping through characteristics")
        if let charactericsArr = service.characteristics{
            for charactericsx in charactericsArr
            {
              //  self.characteristic = charactericsx
                print("esta es la caracteristica:",charactericsx)
                
                peripheral.setNotifyValue(true, for: charactericsx)
               // splitDatagramaEscritura = ParticionaDatagrama().devuelveDatagramas(text: "llllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaavzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
                var pruebaSecuencia = "0"
                for a in 1...85 {
                    pruebaSecuencia += String(a)
                    
                }
                splitDatagramaEscritura = ParticionaDatagrama().devuelveDatagramas(text: pruebaSecuencia)
                let head = [UInt8]("$".utf8)
                let data5 = Data (bytes:head)
                print("\(data5 as NSData)")
                print("mando",head)
                peripheral.writeValue(data5, for: charactericsx,type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if ((error) != nil) {
            print("error cambiando notificación de estado: ");
        }
       
        if characteristic.isNotifying {
            print ("la caracteristica cambia")
        }

        
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
       
        let dat = characteristic.value
        let dataString = String(data: dat!, encoding: String.Encoding.utf8)
        escritura(dataString: dataString!, characteristic: characteristic)
    }
    
    
    
    func escritura (dataString: String,characteristic: CBCharacteristic){
        if dataString != dataStringAnterior{
            
            dataStringAnterior = dataString
            if (dataString.characters.first == "+"){
                
                
                print ("recibo",dataString)
                print ("vuelta numero", i)
                if (i == splitDatagramaEscritura.count + 1){
                    manager.cancelPeripheralConnection(peripheral)
                    i = 0
                }
                    
                else if (i == (splitDatagramaEscritura.count)){
                    //let head = [UInt8](33)
                    let data5 = Data ([33])
                    print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                    
                    i = i + 1
                }
                    
                else {
                    
                    splitDatagramaEscritura[i].insert(0, at:0)
                    let data4 = Data (bytes: splitDatagramaEscritura[i])
                    print("mando", "\(String(describing: String(data: data4, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data4, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                    usleep(30000)
                    i = i + 1
                }
            }
                
                
            else {
                print (dataString)
                
            }
        }
        
    }
   // }
    func lectura (dataString: String,characteristic:CBCharacteristic){
        if dataString.characters.first == "$" {
            let data5 = Data ([43])
            print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
        }
       if dataString.characters.first == "0" {
            let tamañoDatagrama = String(dataString.characters.prefix(2))
            splitDatagramaLectura[i].insert(UInt8(dataString)!, at: 0)
            splitDatagramaLectura[i].insert(UInt8(dataString)!, at: 1)
            let tamañoFor = Int(tamañoDatagrama)
            for a in 2...tamañoFor! {
                splitDatagramaLectura[i].insert(UInt8(dataString)!, at: a)
                
            }
        let data5 = Data ([43])
        print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
        peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
        
        }
        if dataString.characters.first == "!" {
            let data5 = Data ([43])
            print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
        }

        
        
    }


}
extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}*/
/*extension Date {
     var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}*/
