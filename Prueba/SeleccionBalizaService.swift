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
import Alamofire
import SwiftyJSON

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
    func obtenerRegistroBalizas(){
        
        
        do{
            try SQLiteDataStore().createTables()
            print("Tablas creadas con exito nueva db")
        }
        catch {
            print("error al crear las tablas");
        }
        
        let urlstring = "http://192.168.208.254:3000/getDatos"
        
        let parameters : [String: Any] = [
            "idPersona":"7654321",
            "idDispositivo":"AYOZE",
            "estado":"1"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "ayozeapikey123456==",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlstring, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("respuesta al POST con https")
            print("------------------")
            let swiftyJsonVar = JSON(response.result.value!)
            print (swiftyJsonVar)
            print (swiftyJsonVar.count)
            //self.deleteAllRecords()
            var i = 0
            

            let resData = swiftyJsonVar["nsNuevos"]
    
            let resDataMotivos = swiftyJsonVar["mNuevos"]
          
            let resDataGrupos = swiftyJsonVar["gmIdNuevos"]
            
            let resDataEliminar = swiftyJsonVar["nsElim"]
            print(resDataEliminar[0])
            /*for c in 0...resDataEliminar.count {
                do{
                    let item = try BalizasDBManager.buscar(id: Int64(resDataEliminar[c].numberValue))
                    try BalizasDBManager.borrar(item: item! )
                }catch{
                   print ("no se pudo eliminar")
                }
            }*/
            let resDataMotivosEliminar = swiftyJsonVar["mElim"]
            print (resDataMotivosEliminar[0])
            
            let resDataGruposEliminar = swiftyJsonVar["gmIdElim"]
            
            print (resDataGruposEliminar[0])
            while i < resData.count {
                let item = BalizaModelo(
                    idNS: Int64(resData[i]["ns"].numberValue), nombre: resData[i]["nombre"].stringValue, idMaquina: Int64(resData[i]["idmaquinafisica"].numberValue), idMaquinaLogica: Int64(resData[i]["idmaquinalogica"].numberValue), idGMantes: Int64(resData[i]["idgmantes"].numberValue), idGMdentro: Int64(resData[i]["idgmdentro"].numberValue), idGMdespues: Int64(resData[i]["idgmdespues"].numberValue), fechorDesde: Int64(resData[i]["fechahoradesde"].numberValue), fechorHasta:Int64(resData[i]["fechahorahasta"].numberValue), idGMidantes: Int64(resData[i]["idgmidantes"].numberValue), idGMiddentro: Int64(resData[i]["idgmiddentro"].numberValue), idGMiddespues: Int64(resData[i]["idgmiddespues"].numberValue)
                )
                do {
                    
                    let balizaId = try BalizasDBManager.insertar(
                        item: item )

                    //try BalizasDBManager.borrarTabla(nombreTabla: "NSBaliza")

                } catch _{}

                i += 1
            }
            print ("motivos",resDataMotivos)
            print ("tamañoMotivos",resDataMotivos.count)
            var contadorMotivos = 0

            while contadorMotivos < resDataMotivos.count {
                print("variable de motivos", resDataMotivos[contadorMotivos]["nombre"].stringValue)
                let itemMotivo = MotivoModelo(idMotivo:Int64(resDataMotivos[contadorMotivos]["idmotivo"].numberValue) , idGrupo: Int64(resDataMotivos[contadorMotivos]["idgrupomotivo"].numberValue), nombre: resDataMotivos[contadorMotivos]["nombre"].stringValue, letra: resDataMotivos[contadorMotivos]["letra"].stringValue, numero: Int64(resDataMotivos[contadorMotivos]["numero"].numberValue))
                print ("this",itemMotivo)
                do {
                    let motivoId = try MotivoDBManager.insertar(item: itemMotivo)
                    print ("la id del motivo es",motivoId)
                }catch _ {}
             contadorMotivos = contadorMotivos + 1
            }
            do{
                let motivoArray = try MotivoDBManager.ver()
                for item in motivoArray!{
                    print ("motivoc",item)
                }
                let motivoArray2 = try BalizasDBManager.ver()
                for item in motivoArray2!{
                    print ("solo motivo",item)
                }
            }catch _ {}
            var contadorGrupos = 0
            
            while contadorGrupos < resDataGrupos.count {
                var contadorMascaras = 0
                let mascaras = resDataGrupos[contadorGrupos]["mascara"]
                let idgrupo = resDataGrupos[contadorGrupos]["idgrupometodoid"]
                print ("letgrupo",idgrupo)
                print ("mascaraCount", mascaras.count)
                var arrayMascaras = [Int64]()
                var arrayMascarasPermisos = [Int64]()
                
                while contadorMascaras < 20{
                    print ("mascarassss", mascaras[contadorMascaras])
                    arrayMascaras.append(Int64(mascaras[contadorMascaras]["mascaraid"].numberValue))
                    arrayMascarasPermisos.append(Int64(mascaras[contadorMascaras]["mascarapermiso"].numberValue))

                   // let itemGrupoMascara = PivotGrupoMascaraModelo(idgrupo:idgrupo, numeroMascara: mascaras.count, idmascara0: mascaras[contadorMascaras]["idmascara"])

                   
                    contadorMascaras = contadorMascaras + 1
                }
                 print ("arrayMascaras", arrayMascaras)
                print (arrayMascarasPermisos)
                let itemGrupoMascara = PivotGrupoMascaraModelo(idgrupo:Int64(idgrupo.numberValue), numeroMascara:Int64(mascaras.count), idmascara0: arrayMascaras[0],  idmascara1: arrayMascaras[1],  idmascara2: arrayMascaras[2],  idmascara3: arrayMascaras[3],  idmascara4: arrayMascaras[4],  idmascara5: arrayMascaras[5],  idmascara6: arrayMascaras[6],  idmascara7: arrayMascaras[7],  idmascara8: arrayMascaras[8],  idmascara9: arrayMascaras[9],  idmascara10: arrayMascaras[10],  idmascara11: arrayMascaras[11],  idmascara12: arrayMascaras[12],  idmascara13: arrayMascaras[13],  idmascara14: arrayMascaras[14],  idmascara15: arrayMascaras[15], idmascara16: arrayMascaras[16],  idmascara17: arrayMascaras[17],  idmascara18: arrayMascaras[18],  idmascara19: arrayMascaras[19], mascarapermiso0: arrayMascarasPermisos[0], mascarapermiso1: arrayMascarasPermisos[1], mascarapermiso2: arrayMascarasPermisos[2], mascarapermiso3: arrayMascarasPermisos[3], mascarapermiso4: arrayMascarasPermisos[4], mascarapermiso5: arrayMascarasPermisos[5], mascarapermiso6: arrayMascarasPermisos[6], mascarapermiso7: arrayMascarasPermisos[7], mascarapermiso8: arrayMascarasPermisos[8], mascarapermiso9: arrayMascarasPermisos[9], mascarapermiso10: arrayMascarasPermisos[10], mascarapermiso11: arrayMascarasPermisos[11], mascarapermiso12: arrayMascarasPermisos[12], mascarapermiso13: arrayMascarasPermisos[13], mascarapermiso14: arrayMascarasPermisos[14], mascarapermiso15: arrayMascarasPermisos[15], mascarapermiso16: arrayMascarasPermisos[16], mascarapermiso17: arrayMascarasPermisos[17], mascarapermiso18: arrayMascarasPermisos[18], mascarapermiso19: arrayMascarasPermisos[19] )
                
                do{

                    let insertar = try GrupoMascaraDBManager.insertar(item: itemGrupoMascara)

                }catch{
                 print (error)}
                do{
                    let motivoArray3 = try GrupoMascaraDBManager.ver()
                    for item in motivoArray3!{
                        print ("solo grupomascara",item)
                    }
                }catch _ {}
                contadorGrupos = contadorGrupos + 1
            }

            
            //(UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        do{
            try GrupoMascaraDBManager.borrarTabla(nombreTabla: "PivotGrupoMascara")
        }catch _ {}
        
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
/* Alamofire.request("comentarios_addComentario", method: .post, parameters: parametros, encoding: JSONEncoding.default).responseJSON {
 response in
 switch response.result {
 case .success(let value):
 //  TODO BIEN
 case .failure(let error):
 // ERRORES
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
