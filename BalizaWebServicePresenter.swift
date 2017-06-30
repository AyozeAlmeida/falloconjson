//
//  BalizaWebServicePresenter.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import Foundation
import UIKit



struct Balizaa{
    let uuid : String

    
}
struct RegistrosBaliza{
    let horaFichajes : [String]
}
protocol WebServiceView: NSObjectProtocol{
    func setBalizas(balizas: [Baliza])
    
}
class BalizaWebServicePresenter {
    fileprivate let balizaWebService: BalizaWebService
    weak fileprivate var webServiceView : WebServiceViewController?
    
    init(balizaWebService: BalizaWebService) {
        self.balizaWebService = balizaWebService
    }
    
    func attachView(_ view: WebServiceViewController){
        self.webServiceView = view
    }
    
    func detachView() {
        self.webServiceView = nil
    }
    
    func obtenerRegistrosBalizas(){
        self.balizaWebService.obtenerRegistroBalizas(callback: { (Baliza) in
            self.webServiceView?.setBalizas(balizas : Baliza)
           
            
        })
    }
  
}
