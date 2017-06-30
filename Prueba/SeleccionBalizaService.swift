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
    var cachosDatagrama: [[UInt8]] = []
    var i = 0
    func escanea(){
       Escaneado().escaneaBaliza(callback: {(str) in print ("vamos",str)})
    }
    
    func obtenerBalizas(callback:@escaping ([BalizaData]) -> ()) -> Void {
        manager = CBCentralManager (delegate: self, queue: nil)
        // Central Manager
        //Escaneado().escaneaBaliza(callback: {(manager) in print ("vamos",manager)})
        balizas = [BalizaData(uuid: "3340CF08-2A4C-47F4-A360-3FA75561F7A2") , BalizaData(uuid: "33550CF08-2A4C-47F4-A360-3FA75561F7A2") ]
        
        print("este es el uptime ",self.systemUptime())
       // print("UTC",Date().currentUTCTimeZoneDate)
        
        callback(balizas)
    }
    func systemUptime() -> TimeInterval {
        var currentTime = time_t()
        var bootTime = timeval()
        var mib = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.stride
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, 0)
        if result != 0 {
            #if DEBUG
                print("ERROR - \(#file):\(#function) - errno = "
                    + "\(result)")
            #endif
            return 0
        }
        time(&currentTime)
        let uptime = currentTime - bootTime.tv_sec
        return TimeInterval(uptime)
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
extension SeleccionBalizaService: CBCentralManagerDelegate {
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
                cachosDatagrama = ParticionaDatagrama().devuelveDatagramas(text: "llllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaavzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
                let head = [UInt8]("$".utf8)
                let data5 = Data (bytes:head)
                print("\(data5 as NSData)")
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
       
 
        //if var _ :NSData = characteristic.value as NSData? {
           // peripheral.readValue(for: characteristic)
           // print("recibo", characteristic)
        
        //print("deeeeeeeeee", characteristic)
           /* guard var bytesReceived = characteristic.value else {
                return
            }
            
            bytesReceived.withUnsafeBytes { (utf8Bytes: UnsafePointer<CChar>) in
                var len = bytesReceived.count
                print(len)
                if utf8Bytes[len - 1] == 0 {
                    len -= 1 // if the string is null terminated, don't pass null terminator into NSMutableString constructor
                }
                
                if let validUTF8String = String(utf8String: utf8Bytes) {//  NSMutableString(bytes: utf8Bytes, length: len, encoding: String.Encoding.utf8.rawValue) {
                    print ("recibo", validUTF8String)
                    if (validUTF8String.characters.first == "+") {*/
        
        let dat = characteristic.value
        var dataString = String(data: dat!, encoding: String.Encoding.utf8)
        if dataString != dataStringAnterior{
            dataStringAnterior = dataString!
        if (dataString?.characters.first == "+"){
                        print ("recibo",dataString)
                        print ("vuelta numero", i)
                        if (i == cachosDatagrama.count + 1){
                            manager.cancelPeripheralConnection(peripheral)
                            i = 0
                        }
                            
                        else if (i == (cachosDatagrama.count)){
                            //let head = [UInt8](33)
                            let data5 = Data ([33])
                            print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
                            peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                            
                            i = i + 1
                        }

                        else {
                            cachosDatagrama[i].insert(0, at:0)
                            let data4 = Data (bytes: cachosDatagrama[i])
                            print("mando", "\(String(describing: String(data: data4, encoding: String.Encoding.utf8)))")
                            peripheral.writeValue(data4, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                            i = i + 1
                        }
                    }
                    
    
            else {
                    print (dataString)
                    
                }
        }
        }
   // }


}


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
