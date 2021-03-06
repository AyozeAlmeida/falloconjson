//
//  Baliza.swift
//  Prueba
//
//  Created by Ayoze on 6/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation

class BalizaSQLite: CustomStringConvertible {
    let id: Int64?
    var name: String
    var imageName: String
    
    init(id: Int64, name: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }
    var description: String {
        return "id = \(self.id ?? 0), name = \(self.name), imageName = \(self.imageName)"
    }
}
