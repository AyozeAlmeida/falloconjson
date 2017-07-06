//
//  DevuelveFechor.swift
//  Prueba
//
//  Created by Ayoze on 6/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation

class DevuelveFechor {
    
    
    func devuelveBytesFechor() -> [UInt8]{
        let date = NSDate()
        var fechor : [UInt8] = []
        // *** create calendar object ***
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        // *** Get components using current Local & Timezone ***
        
        let datecomponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        var año = datecomponent.year
        año = año! % 100
        let mes = datecomponent.month
        let dia = datecomponent.day
        let hora = datecomponent.hour
        let minutos = datecomponent.minute
        let segundos = datecomponent.second
        //fechor.append(6)
        fechor.append(UInt8(año!))
        fechor.append(UInt8(mes!))
        fechor.append(UInt8(dia!))
        fechor.append(UInt8(hora!))
        fechor.append(UInt8(minutos!))
        fechor.append(UInt8(segundos!))
        print (fechor)
        return fechor 
    }
}
