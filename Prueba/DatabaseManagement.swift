//
//  DatabaseManagement.swift
//  Prueba
//
//  Created by Ayoze on 6/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation
import SQLite


class DatabaseManagement {
    
    
    static let shared:DatabaseManagement = DatabaseManagement()
    private var db:Connection?
    private let tblBaliza = Table("baliza")
    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let imageName = Expression<String>("imageName")
    
    
    
    public init(){
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        print("\(path)")
        
        
        do{
            db = try Connection("\(path)/pruebaa.sqlite")
            
            let tblProduct = Table("product")
            
            try db!.run(tblProduct.drop(ifExists: true)) //borrar tabla 
            
            print ("enable")
            createTableProduct()
           //let baliza = BalizaSQLite(id: 7, name: "JJJJ", imageName: "IMAGEN")
            let baliza2 = BalizaSQLite(id: 7, name: "DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE", imageName: "IMAGENotra")
            //let insert = tblBaliza.insert(name <- baliza.name, imageName <- baliza.imageName)
            addBaliza(inputName: baliza2.name, inputImageName: "imagendebaliza")
            //let id = try db!.run(insert)
            
            updateContact(productId: 3, newProduct: baliza2)
            
            //deleteProduct(inputId: 1)
            
            queryAllProduct()
            
        }catch {
            db = nil
            print ("Unable to open database")
        }
        
    }
    
    func createTableProduct() {
        do {
            try
                
                db!.run(tblBaliza.create(ifNotExists: true) { table in
                    table.column(id, primaryKey: true)
                    table.column(name)
                    
                    table.column(imageName)
                    print("create table successfully")
                })
            
        } catch {
            print("Unable to create table")
        }
    }
    
    
    func addBaliza(inputName: String, inputImageName: String) -> Int64? {
        do {
            let insert = tblBaliza.insert(name <- inputName, imageName <- inputImageName)
            let id = try db!.run(insert)
            print("Insert to tblBaliza successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllProduct() -> [BalizaSQLite] {
        var balizas = [BalizaSQLite]()
        
        do {
            for baliza in try db!.prepare(self.tblBaliza) {
                let nuevaBaliza = BalizaSQLite(id: baliza[id],
                                        name: baliza[name] ?? "",
                                        imageName: baliza[imageName])
                balizas.append(nuevaBaliza)
            }
        } catch {
            print("Cannot get list of product")
        }
        for baliza in balizas {
            print("vemos las balizas = \(baliza)")

        }
        return balizas
    }
    func evalueBaliza(identificador:String) -> Bool{
        var balizas = [BalizaSQLite]()
        
        do {
            for baliza in try db!.prepare(self.tblBaliza) {
                let nuevaBaliza = BalizaSQLite(id: baliza[id],
                                               name: baliza[name] ?? "",
                                               imageName: baliza[imageName])
                balizas.append(nuevaBaliza)
            }
        } catch {
            print("Cannot get list of product")
        }
        for baliza in balizas {
            if baliza.name == identificador{
                return true
            }
            
        }
        return false
    }
    func updateContact(productId:Int64, newProduct: BalizaSQLite) -> Bool {
        let tblFilterProduct = tblBaliza.filter(id == productId)
        do {
            let update = tblFilterProduct.update([
                name <- newProduct.name,
                imageName <- newProduct.imageName
                ])
            if try db!.run(update) > 0 {
                print("Update contact successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteProduct(inputId: Int64) -> Bool {
        do {
            let tblFilterProduct = tblBaliza.filter(id == inputId)
            try db!.run(tblFilterProduct.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    
}


