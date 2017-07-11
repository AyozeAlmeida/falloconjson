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
    
    
   /* static let shared:DatabaseManagement = DatabaseManagement()
    private var db:Connection?
    private let tblBaliza = Table("baliza")
    private let name = Expression<String?>("name")
    private let imageName = Expression<String>("imageName")
    
    
    
    
    private let tblBaliza2 = Table("baliza2")
    private let id = Expression<Int64>("id")
   // private let id = Expression<Int64>("id")
    private let idMaquina = Expression<Int64>("idMaquina")
    private let idMaquinaLogica = Expression<Int64>("idMaquinaLogica")
    private let nombre = Expression<String?>("nombre")
    private let idGmAntes = Expression<Int64>("idGmAntes")
    private let idGmDentro = Expression<Int64>("idGmDentro")
    private let idGmDespues = Expression<Int64>("idGmDespues")
    private let fechorDesde = Expression<Int64>("fechorDesde")
    private let fechorHasta = Expression<Int64>("fechorHasta")
    private let idGmIdAntes = Expression<Int64>("idGmIdAntes")
    private let idGmIdDespues = Expression<Int64>("idGmIdDespues")
    private let idGmIdDentro = Expression<Int64>("idGmIdDentro")
    private let idBaliza = Expression<Int64>("idBaliza")
   
    
    
    
    
    public init(){
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        print("\(path)")
        
        
        do{
            db = try Connection("\(path)/pruebaa.sqlite")
            
            let tblProduct = Table("product")
            let tblBaliza2 = Table("baliza2")
            
            try db!.run(tblProduct.drop(ifExists: true)) //borrar tabla
            try db!.run(tblBaliza2.drop(ifExists: true))
            
            print ("enable")
            createTableProduct()
            createTableBaliza()
           //let baliza = BalizaSQLite(id: 7, name: "JJJJ", imageName: "IMAGEN")
            //let baliza2 = BalizaSQLite(id: 7, name: "3340CF08-2A4C-47F4-A360-3FA75561F7A2", imageName: "IMAGENotra")
           // let insert = tblBaliza.insert(name <- baliza2.name, imageName <- baliza2.imageName)
            let balizaV = Baliza2(id: 7, idBaliza: 7, idMaquina: 7, idMaquinaLogica: 7, nombre: "primera", idGmAntes: 7, idGmDentro: 7, idGmDespues: 7, fechorDesde: 7, fechorHasta: 7, idGmIdAntes: 7, idGmIdDespues: 7, idGmIdDentro: 7)
            let insert2 = tblBaliza2.insert(idBaliza <- balizaV.idBaliza!, idMaquina <- balizaV.idMaquina!, idMaquinaLogica <- balizaV.idMaquinaLogica!, nombre <- balizaV.nombre, idGmAntes <- balizaV.idGmAntes!, idGmDentro <- balizaV.idGmDentro!, idGmDespues <- balizaV.idGmDespues!, fechorDesde <- balizaV.fechorDesde!, fechorHasta <- balizaV.fechorHasta!, idGmIdAntes <- balizaV.idGmIdAntes!, idGmIdDentro <- balizaV.idGmIdDentro!, idGmIdDespues <- balizaV.idGmIdDespues!)
            //addBaliza(inputName: baliza2.name, inputImageName: "imagendebaliza")
            //let id = try db!.run(insert)
           let id2 = try db!.run(insert2)
            
            //updateContact(productId: 3, newProduct: baliza2)
            
            //deleteProduct(inputId: 1)
            
           // queryAllProduct()
            queryAllBalizas()
            
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
    func createTableBaliza() {
        do {
            try
            
                db!.run(tblBaliza2.create(ifNotExists:true) { table in
                    table.column(id, primaryKey:true)
                    table.column(idBaliza)
                    table.column(idMaquina)
                    table.column(idMaquinaLogica)
                    table.column(nombre)
                    table.column(idGmAntes)
                    table.column(idGmDentro)
                    table.column(idGmDespues)
                    table.column(fechorDesde)
                    table.column(fechorHasta)
                    table.column(idGmIdAntes)
                    table.column(idGmIdDentro)
                    table.column(idGmIdDespues)
                    print("creada tabla baliza 2")
                })
        }catch{
            print ("nosepudo crear baliza 2")
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
    
    
    func queryAllBalizas() -> [Baliza2] {
        var balizas = [Baliza2]()
        do {
            for baliza in try db!.prepare(self.tblBaliza2){
                let nuevaBaliza = Baliza2(id: baliza[id], idBaliza: baliza[idBaliza], idMaquina:baliza[idMaquina] , idMaquinaLogica: baliza[idMaquinaLogica], nombre: baliza[nombre] ?? "", idGmAntes: baliza[idGmAntes], idGmDentro: baliza[idGmDentro], idGmDespues: baliza[idGmDespues], fechorDesde: baliza[fechorDesde], fechorHasta: baliza[fechorHasta], idGmIdAntes: baliza[idGmIdAntes], idGmIdDespues: baliza[idGmIdDespues], idGmIdDentro: baliza[idGmIdDentro])
                balizas.append(nuevaBaliza)
            }
            
        }
        catch {
            print ("no se pudo obtener las balizas")
        }
        for baliza in balizas {
        print ("vemos las balizas2 = \(baliza)")
        }
        return balizas
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
     /*func addBaliza( idBaliza: Int64, idMaquina: Int64, idMaquinaLogica: Int64, nombre: String, idGmAntes: Int64, idGmDentro: Int64, idGmDespues: Int64, fechorDesde: Date, fechorHasta: Date, idGmIdAntes: Int64, idGmIdDespues: Int64, idGmIdDentro: Int64)-> Int64{
     do{
     
     let insert2 = tblBaliza2.insert(idBaliza <- idBaliza, idMaquina <- idMaquina, idMaquinaLogica <- idMaquinaLogica, nombre <- nombre, idGmAntes <- idGmAntes, idGmDentro <- idGmDentro, idGmDespues <- idGmDespues, fechorDesde <- fechorDesde, fechorHasta <- fechorHasta, idGmIdAntes <- idGmIdAntes, idGmIdDentro <- idGmIdDentro, idGmIdDespues <- idGmIdDespues)
     return id
     
     }catch{
     
     }
     }*/
    
}

*/
