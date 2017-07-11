//
//  BalizaWebService.swift
//  Prueba
//
//  Created by Ayoze on 6/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//
//
//  BalizaWebService.swift
//  Prueba
//
//  Created by Ayoze on 26/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class BalizaWebService {
    var balizas: [Baliza] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func obtenerRegistroBalizas(callback:@escaping ([Baliza]) -> ())  -> Void {
        
        let urlstring = "https://www.loquatsolutions.com/detres/detres/api/modificarNombreProducto"
        
        let parameters : [String: Any] = [
            "id":"10",
            "nombre":"SWITFeell"
            
        ]
        let headers: HTTPHeaders = [
            "Authorization": "ayozeapikey123456==",
            "Accept": "application/json"
        ]
        
        
        
        
        /* Alamofire.request("comentarios_addComentario", method: .post, parameters: parametros, encoding: JSONEncoding.default).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         //  TODO BIEN
         case .failure(let error):
         // ERRORES
         }
         
         }*/
        
        
        
        Alamofire.request(urlstring, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("respuesta al POST con https")
            print("------------------")
            let swiftyJsonVar = JSON(response.result.value!)
            print (swiftyJsonVar.count)
            self.deleteAllRecords()
            var i = 0
            while i <= swiftyJsonVar.count {
                let resData = swiftyJsonVar[i]
                let valor = resData["nombre"].string
                let baliza = Baliza(context: self.context)
                baliza.uuid = valor
                i += 1
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        getData()
        if (balizas == nil){
            callback([])
        }
        callback(balizas)
        
        
    }
    func getData() {
        do {
            balizas = try context.fetch(Baliza.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    func deleteAllRecords() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Baliza")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
