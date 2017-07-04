//
//  Firmado.swift
//  Prueba
//
//  Created by Ayoze on 3/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

//
//  Firmado.swift
//  Proyectito
//
//  Created by Loquat Solutions on 28/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol ProtocoloFirmado {
    func perifericoFirmado ()
}

class Firmado: NSObject  {
    
    var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    var presenter: SeleccionBalizaPresenter!
    var dataStringAnterior : String = ""
    var splitDatagramaEscritura: [[UInt8]] = []
    //var splitDatagramaLectura: [[UInt8]] = []
    var datagramaLectura = ""
    var paso = false;
    var i = 0
    
    
    func inicializarFirmado(presenter: SeleccionBalizaPresenter, manager: CBCentralManager, peripheral: CBPeripheral) {
        self.presenter = presenter
        self.manager = manager
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        manager.connect(peripheral, options: nil)
        
        
        
    }
    
    func systemUptime() -> TimeInterval {
        
        
        var currentTime = time_t()
        var bootTime    = timeval()
        var mib         = [CTL_KERN, KERN_BOOTTIME]
        
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



extension Firmado: CBPeripheralDelegate {
    
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
                print("esta es la caracteristica:",charactericsx)
            
                peripheral.setNotifyValue(true, for: charactericsx) //mucho ojo con subcribirse a la carácteristica pq satura el micro de la baliza
                // splitDatagramaEscritura = ParticionaDatagrama().devuelveDatagramas(text: "llllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaamuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaallllllllllllllllllllxxxxxxxxxxxxxxxxxmmmmmmmmmmmmmuuuuuuuuuuuuuuuuuuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaavzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
                /*let datos = "manolitofichaenlabalizatalconelconceptocual"
                splitDatagramaEscritura = ParticionaDatagrama().devuelveDatagramas(text: "<"+Date().currentUTCTimeZoneDate+String(datos.length)+datos)*/
                var pruebaSecuencia = "0"
                for a in 1...140 {
                    pruebaSecuencia += String(a)
                    
                }
                splitDatagramaEscritura = ParticionaDatagrama().devuelveDatagramas(text: pruebaSecuencia)
                let head = [UInt8]("$".utf8)
                let data5 = Data (bytes:head)
                print("\(data5 as NSData)")
                print("mando",head)
                peripheral.writeValue(data5, for: charactericsx,type: CBCharacteristicWriteType.withResponse)
                peripheral.readValue(for: charactericsx)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if ((error) != nil) {
            print("error cambiando notificación de estado: ");
        }
        
        if characteristic.isNotifying {
            print ("estado en escucha")

        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let dat = characteristic.value
        let dataString = String(data: dat!, encoding: String.Encoding.utf8)
        //peripheral.setNotifyValue(false, for: characteristic)
        /*if (dataString?.characters.first == "$") {
            lectura(dataString: dataString!, characteristic: characteristic)
        }*/
       
        
        escritura(dataString: dataString!, characteristic: characteristic)
      

    }
    
    
    
    func escritura (dataString: String,characteristic: CBCharacteristic){
        if dataString != dataStringAnterior{
            dataStringAnterior = dataString
            if (dataString.characters.first == "+"){
                
                paso = true;
                print ("recibo", dataString)
                print ("vuelta numero", i)
                if (i == splitDatagramaEscritura.count + 1){
                    print ("desconecto")
                    manager.cancelPeripheralConnection(peripheral)
                    i = 0
                }
                
                if (i == (splitDatagramaEscritura.count)){
                    //peripheral.setNotifyValue(false, for: characteristic)
                    let data5 = Data ([33])
                    print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data5, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    //usleep(300)
                    //peripheral.readValue(for: characteristic)
                    
                    i = i + 1
                }
                    
                else if (i <= splitDatagramaEscritura.count) {
                    splitDatagramaEscritura[i].insert(0, at:0)
                    let data4 = Data (bytes: splitDatagramaEscritura[i])
                    print("mando", "\(String(describing: String(data: data4, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data4, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                    //usleep(300)
                    //peripheral.readValue(for: characteristic)
                    i = i + 1
                }
                
            }
            
        }
        print ("eeeoo", dataString, i)
        
    }
    
    func lectura (dataString: String,characteristic:CBCharacteristic){
        if dataString.characters.first == "$" {
            let data5 = Data ([43])
            print("mando", "\(String(describing: String(data: data5, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data5, for: characteristic,type: CBCharacteristicWriteType.withResponse)
        }
        if dataString.characters.first == "0" {
            let tamañoDatagrama = String(dataString.characters.prefix(2))
            
            let tamañoFor = Int(tamañoDatagrama)
            for a in 2...tamañoFor! {
                datagramaLectura += dataString[a]
                
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
    
}
extension Date {
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
}
}
