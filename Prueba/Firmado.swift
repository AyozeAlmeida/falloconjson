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
    var dataAnterior : UInt8 = 9
    var splitDatagramaEscritura: [[UInt8]] = []
    //var splitDatagramaLectura: [[UInt8]] = []
    var lecturaOEscritura = false
    var datagramaLectura : [UInt8] = []
    var timer = Timer ()
    var paso = false;
    var i = 0
    var characteristicAnterior: CBCharacteristic? = nil
    
    
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
    
    func timeOut(){
        print ("tiempo Agotado")
        manager.cancelPeripheralConnection(peripheral)
        presenter.escan()
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
            //timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.timeOut), userInfo: nil, repeats: true)

            for charactericsx in charactericsArr
            {
                print("esta es la caracteristica:",charactericsx)
                peripheral.setNotifyValue(true, for: charactericsx)
                let datagramaFechor : [UInt8] = ProtocoloFechor().protocoloFechor(datos: [97, 98, 99, 100])
                
                
                splitDatagramaEscritura = ParticionaDatagrama().devuelveByte(byte:datagramaFechor)
                print (datagramaFechor)
                let head = [UInt8]("$".utf8)
                let data5 = Data (bytes:head)
                print("\(data5 as NSData)")
                print("mando inicio",head)
                peripheral.writeValue(data5, for: charactericsx,type: CBCharacteristicWriteType.withResponse)

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
        print ("escucho")
        let dat = characteristic.value
        let dataString = String(data: dat!, encoding: String.Encoding.utf8)
        //print ("eeoo", dataString)
        //peripheral.setNotifyValue(false, for: characteristic)
        if (dataString?.characters.first == "$") {
            lecturaOEscritura = true
            lectura(characteristic: characteristic)
        }
        if lecturaOEscritura == true {
            lectura(characteristic: characteristic)
        }
      
        if lecturaOEscritura == false && dataString != nil {
        escritura(dataString: dataString!, characteristic: characteristic)
      
        }
    }
    
    
    
    func escritura (dataString: String,characteristic: CBCharacteristic){
        
        if dataString != dataStringAnterior{
            dataStringAnterior = dataString
            print ("escribo")
            if (dataString.characters.first == "#"){
                print ("desconecto")
                //manager.cancelPeripheralConnection(peripheral)
                lecturaOEscritura = true
                i = 0
            }
            if (dataString.characters.first == "+"){
                if (dataString.characters.first == "!"){
                    print ("desconecto")
                    //manager.cancelPeripheralConnection(peripheral)
                    lecturaOEscritura = true
                    i = 0
                }
               
                print ("recibo", dataString)
                print ("vuelta numero", i)
                
                if (i == (splitDatagramaEscritura.count)){
                    //peripheral.setNotifyValue(false, for: characteristic)
                    let data = Data ([33])
                    print("mando !", "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    i = i + 1
                }
                if (i < splitDatagramaEscritura.count) {
                    splitDatagramaEscritura[i].insert(0, at:0)
                    let data = Data (bytes: splitDatagramaEscritura[i])
                    print("mando cacho", "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
                    peripheral.writeValue(data, for: characteristic,type: CBCharacteristicWriteType.withResponse)
                    i = i + 1
                }
                
            }
            
        }

        
    }
    
    func lectura (characteristic:CBCharacteristic){
        print ("leo")

        guard let data1 = characteristic.value else {
            return
        }

        lecturaOEscritura = true
        if data1[0] == 36 {
            print (data1[0])
            print ("tamaño", data1[1])
            print(characteristic)
            let data = Data ([43])
            print("mando lectura", "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data, for: characteristic,type: CBCharacteristicWriteType.withResponse)
            
        }
        if data1[0] == 0 {
            let tamaño = data1[1]
            let num : Int = Int(tamaño)
            
            
            for s in 2...num {
              datagramaLectura.append(data1[s])
            }
            print (datagramaLectura)
            let data = Data ([43])
            print("mando confirmación leo cacho", "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data, for: characteristic,type: CBCharacteristicWriteType.withResponse)
            
        }
        print (characteristic)
        print (data1[0])
        if data1[0] == 33 {
            let data = Data ([43])
            print("mando fin lectura", "\(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
            peripheral.writeValue(data, for: characteristic,type: CBCharacteristicWriteType.withResponse)
            lecturaOEscritura = false
            print ("fin de lectura")
           /* let head = [UInt8]("$".utf8)
            let data2 = Data (bytes:head)
            print("\(data2 as NSData)")
            print("mando",head)
            peripheral.writeValue(data2, for: characteristic,type: CBCharacteristicWriteType.withResponse)*/
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
