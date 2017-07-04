//
//  ParticionaDatagrama.swift
//  Prueba
//
//  Created by Ayoze on 29/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import CoreBluetooth

class ParticionaDatagrama: NSObject {
    var cachosDatagrama: [[UInt8]] = []
    
    
    func devuelveDatagramas (text: String) -> [[UInt8]]{
        send (text: text)
        return cachosDatagrama
    }
    
    func send(text aText : String) {
        
        let type = CBCharacteristicWriteType.withResponse
        let MTU = 18
        let longWriteSupported = false
        let textData = aText.data(using: String.Encoding.utf8)!
        
        textData.withUnsafeBytes { (u8Ptr: UnsafePointer<CChar>) in
            var buffer = UnsafeMutableRawPointer(mutating: UnsafeRawPointer(u8Ptr))
            var len = textData.count
            while(len != 0){
                var part : String
                if len > MTU && (type == CBCharacteristicWriteType.withoutResponse || longWriteSupported == false) {
                    var builder = NSMutableString(bytes: buffer, length: MTU, encoding: String.Encoding.utf8.rawValue)
                    if builder != nil {
                        buffer  = buffer + MTU
                        len     = len - MTU
                    } else {
                        builder = NSMutableString(bytes: buffer, length: (MTU - 1), encoding: String.Encoding.utf8.rawValue)
                        buffer = buffer + (MTU - 1)
                        len    = len - (MTU - 1)
                    }
                    part = String(describing: builder!)
                } else {
                    let builder = NSMutableString(bytes: buffer, length: len, encoding: String.Encoding.utf8.rawValue)
                    part = String(describing: builder!)
                    len = 0
                }
                send(text: part, withType: type)
            } 
        }
    }
    
    func send(text aText : String, withType aType : CBCharacteristicWriteType) {
        
        _ = aType == .withoutResponse ? ".withoutResponse" : ".withResponse"
        let tam = aText.lengthOfBytes(using: .utf8)
        var byte = [UInt8](aText.utf8)
        byte.insert(UInt8(tam), at: 0)

        cachosDatagrama.append(byte)
        
    }
}
    
    
