//
//  GruposMascarasDBManager.swift
//  Prueba
//
//  Created by Ayoze on 11/7/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import Foundation

import SQLite

import SwiftyJSON






/* typealias GrupoMascaraModelo = (
 idgrupometodoid: Int64?,
 idmascara: [MascaraModelo]?
 )
 */



typealias PivotGrupoMascaraModelo = (
    idgrupo: Int64?,
    numeroMascara: Int64?,
    idmascara0: Int64?,
    idmascara1: Int64?,
    idmascara2: Int64?,
    idmascara3: Int64?,
    idmascara4: Int64?,
    idmascara5: Int64?,
    idmascara6: Int64?,
    idmascara7: Int64?,
    idmascara8: Int64?,
    idmascara9: Int64?,
    idmascara10: Int64?,
    idmascara11: Int64?,
    idmascara12: Int64?,
    idmascara13: Int64?,
    idmascara14: Int64?,
    idmascara15: Int64?,
    idmascara16: Int64?,
    idmascara17: Int64?,
    idmascara18: Int64?,
    idmascara19: Int64?,
    mascarapermiso0: Int64?,
    mascarapermiso1: Int64?,
    mascarapermiso2: Int64?,
    mascarapermiso3: Int64?,
    mascarapermiso4: Int64?,
    mascarapermiso5: Int64?,
    mascarapermiso6: Int64?,
    mascarapermiso7: Int64?,
    mascarapermiso8: Int64?,
    mascarapermiso9: Int64?,
    mascarapermiso10: Int64?,
    mascarapermiso11: Int64?,
    mascarapermiso12: Int64?,
    mascarapermiso13: Int64?,
    mascarapermiso14: Int64?,
    mascarapermiso15: Int64?,
    mascarapermiso16: Int64?,
    mascarapermiso17: Int64?,
    mascarapermiso18: Int64?,
    mascarapermiso19: Int64?
    
    
    
)



class GrupoMascaraDBManager {
    
    
    
    
    static let TABLE_NAME = "PivotGrupoMascara"
    
    static let table = Table(TABLE_NAME)
    
    
    static let idgrupo = Expression<Int64>("idgrupo")
    static let numeroMascara = Expression<Int64>("numeroMascara")
    static let idmascara0 = Expression<Int64>("idmascara0")
    static let idmascara1 = Expression<Int64>("idmascara1")
    static let idmascara2 = Expression<Int64>("idmascara2")
    static let idmascara3 = Expression<Int64>("idmascara3")
    static let idmascara4 = Expression<Int64>("idmascara4")
    static let idmascara5 = Expression<Int64>("idmascara5")
    static let idmascara6 = Expression<Int64>("idmascara6")
    static let idmascara7 = Expression<Int64>("idmascara7")
    static let idmascara8 = Expression<Int64>("idmascara8")
    static let idmascara9 = Expression<Int64>("idmascara9")
    static let idmascara10 = Expression<Int64>("idmascara10")
    static let idmascara11 = Expression<Int64>("idmascara11")
    static let idmascara12 = Expression<Int64>("idmascara12")
    static let idmascara13 = Expression<Int64>("idmascara13")
    static let idmascara14 = Expression<Int64>("idmascara14")
    static let idmascara15 = Expression<Int64>("idmascara15")
    static let idmascara16 = Expression<Int64>("idmascara16")
    static let idmascara17 = Expression<Int64>("idmascara17")
    static let idmascara18 = Expression<Int64>("idmascara18")
    static let idmascara19 = Expression<Int64>("idmascara19")
    static let mascaraPermiso0 = Expression<Int64>("mascaraPermiso0")
     static let mascaraPermiso1 = Expression<Int64>("mascaraPermiso1")
     static let mascaraPermiso2 = Expression<Int64>("mascaraPermiso2")
     static let mascaraPermiso3 = Expression<Int64>("mascaraPermiso3")
     static let mascaraPermiso4 = Expression<Int64>("mascaraPermiso4")
     static let mascaraPermiso5 = Expression<Int64>("mascaraPermiso5")
     static let mascaraPermiso6 = Expression<Int64>("mascaraPermiso6")
     static let mascaraPermiso7 = Expression<Int64>("mascaraPermiso7")
     static let mascaraPermiso8 = Expression<Int64>("mascaraPermiso8")
     static let mascaraPermiso9 = Expression<Int64>("mascaraPermiso9")
     static let mascaraPermiso10 = Expression<Int64>("mascaraPermiso10")
     static let mascaraPermiso11 = Expression<Int64>("mascaraPermiso11")
     static let mascaraPermiso12 = Expression<Int64>("mascaraPermiso12")
     static let mascaraPermiso13 = Expression<Int64>("mascaraPermiso13")
     static let mascaraPermiso14 = Expression<Int64>("mascaraPermiso14")
     static let mascaraPermiso15 = Expression<Int64>("mascaraPermiso15")
     static let mascaraPermiso16 = Expression<Int64>("mascaraPermiso16")
     static let mascaraPermiso17 = Expression<Int64>("mascaraPermiso17")
     static let mascaraPermiso18 = Expression<Int64>("mascaraPermiso18")
     static let mascaraPermiso19 = Expression<Int64>("mascaraPermiso19")
    
    
    
    
    typealias PGM = PivotGrupoMascaraModelo
    
    
    
    static func borrarTabla(nombreTabla: String) throws  {
        // borrar tabla
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let table = Table(nombreTabla)
        
        do {
            
            try DB.run(table.drop(ifExists: true))
            print("se ha borrado la tabla")
        } catch {
            print("Error al borrar la tabla ")
            
        }
        
    }
    
    
    static func crearTabla() throws {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {table in
                table.column(idgrupo, primaryKey: true)
                table.column(numeroMascara)
                table.column(idmascara1)
                table.column(idmascara2)
                table.column(idmascara3)
                table.column(idmascara4)
                table.column(idmascara5)
                table.column(idmascara6)
                table.column(idmascara7)
                table.column(idmascara8)
                table.column(idmascara9)
                table.column(idmascara10)
                table.column(idmascara11)
                table.column(idmascara12)
                table.column(idmascara13)
                table.column(idmascara14)
                table.column(idmascara15)
                table.column(idmascara16)
                table.column(idmascara17)
                table.column(idmascara18)
                table.column(idmascara19)
                table.column(mascaraPermiso0)
                table.column(mascaraPermiso1)
                table.column(mascaraPermiso2)
                table.column(mascaraPermiso3)
                table.column(mascaraPermiso4)
                table.column(mascaraPermiso5)
                table.column(mascaraPermiso6)
                table.column(mascaraPermiso7)
                table.column(mascaraPermiso8)
                table.column(mascaraPermiso9)
                table.column(mascaraPermiso10)
                table.column(mascaraPermiso11)
                table.column(mascaraPermiso12)
                table.column(mascaraPermiso13)
                table.column(mascaraPermiso14)
                table.column(mascaraPermiso15)
                table.column(mascaraPermiso16)
                table.column(mascaraPermiso17)
                table.column(mascaraPermiso18)
                table.column(mascaraPermiso19)
                
                
                
                print("tabla PivotGrupoMascara creada con exito")            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    static func insertar(item: PGM) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        print("entro en insertar")
        if (item.idgrupo != nil) {
            let insert = table.insert(idgrupo <- item.idgrupo!, numeroMascara <- item.numeroMascara!, idmascara0 <- item.idmascara0!, idmascara1 <- item.idmascara1!, idmascara2 <- item.idmascara2!, idmascara3 <- item.idmascara3!, idmascara4 <- item.idmascara4!, idmascara5 <- item.idmascara5!, idmascara6 <- item.idmascara6!, idmascara7 <- item.idmascara7!, idmascara8 <- item.idmascara8!, idmascara9 <- item.idmascara9!, idmascara10 <- item.idmascara10!, idmascara11 <- item.idmascara11!, idmascara12 <- item.idmascara12!, idmascara13 <- item.idmascara13!, idmascara14 <- item.idmascara14!, idmascara15 <- item.idmascara15!, idmascara16 <- item.idmascara16!, idmascara17 <- item.idmascara17!, idmascara18 <- item.idmascara18!, idmascara19 <- item.idmascara19!, mascaraPermiso0 <- item.mascarapermiso0!, mascaraPermiso1 <- item.mascarapermiso1!, mascaraPermiso2 <- item.mascarapermiso2!, mascaraPermiso3 <- item.mascarapermiso3!, mascaraPermiso4 <- item.mascarapermiso4!, mascaraPermiso5 <- item.mascarapermiso5!, mascaraPermiso6 <- item.mascarapermiso6!, mascaraPermiso7 <- item.mascarapermiso7!, mascaraPermiso8 <- item.mascarapermiso8!, mascaraPermiso9 <- item.mascarapermiso9!, mascaraPermiso10 <- item.mascarapermiso10!, mascaraPermiso11 <- item.mascarapermiso11!, mascaraPermiso12 <- item.mascarapermiso12!, mascaraPermiso13 <- item.mascarapermiso13!, mascaraPermiso14 <- item.mascarapermiso14!, mascaraPermiso15 <- item.mascarapermiso15!, mascaraPermiso16 <- item.mascarapermiso16!, mascaraPermiso17 <- item.mascarapermiso17!, mascaraPermiso18 <- item.mascarapermiso18!, mascaraPermiso19 <- item.mascarapermiso19!)
            do {
                print(insert)
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error.localizedDescription)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado en pivotgrupomascara")
                return rowId
            } catch _ {
                throw DataAccessError.Insert_Error
            }
        }
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func borrar (item: PGM) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if let id = item.idgrupo {
            let query = table.filter(idgrupo == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    print(DataAccessError.Delete_Error)
                    throw DataAccessError.Delete_Error
                }
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    
    static func actualizar(item: PGM)  throws -> Int64 {
        
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(item.idgrupo! == idgrupo)
      //  let grupos =  try DB.prepare(query)
        
        do {
            let update = table.update([idgrupo <- item.idgrupo!, numeroMascara <- item.numeroMascara!, idmascara0 <- item.idmascara0!, idmascara1 <- item.idmascara1!, idmascara2 <- item.idmascara2!, idmascara3 <- item.idmascara3!, idmascara4 <- item.idmascara4!, idmascara5 <- item.idmascara5!, idmascara6 <- item.idmascara6!, idmascara7 <- item.idmascara7!, idmascara8 <- item.idmascara8!, idmascara9 <- item.idmascara9!, idmascara10 <- item.idmascara10!, idmascara11 <- item.idmascara11!, idmascara12 <- item.idmascara12!, idmascara13 <- item.idmascara13!, idmascara14 <- item.idmascara14!, idmascara15 <- item.idmascara15!, idmascara16 <- item.idmascara16!, idmascara17 <- item.idmascara17!, idmascara18 <- item.idmascara18!, idmascara19 <- item.idmascara19!, mascaraPermiso0 <- item.mascarapermiso0!, mascaraPermiso1 <- item.mascarapermiso1!, mascaraPermiso2 <- item.mascarapermiso2!, mascaraPermiso3 <- item.mascarapermiso3!, mascaraPermiso4 <- item.mascarapermiso4!, mascaraPermiso5 <- item.mascarapermiso5!, mascaraPermiso6 <- item.mascarapermiso6!, mascaraPermiso7 <- item.mascarapermiso7!, mascaraPermiso8 <- item.mascarapermiso8!, mascaraPermiso9 <- item.mascarapermiso9!, mascaraPermiso10 <- item.mascarapermiso10!, mascaraPermiso11 <- item.mascarapermiso11!, mascaraPermiso12 <- item.mascarapermiso12!, mascaraPermiso13 <- item.mascarapermiso13!, mascaraPermiso14 <- item.mascarapermiso14!, mascaraPermiso15 <- item.mascarapermiso15!, mascaraPermiso16 <- item.mascarapermiso16!, mascaraPermiso17 <- item.mascarapermiso17!, mascaraPermiso18 <- item.mascarapermiso18!, mascaraPermiso19 <- item.mascarapermiso19!
                ])
            
            do {
                let rowId = try DB.run(update)
                guard rowId > 0 else {
                    
                    print(DataAccessError.Insert_Error)
                    throw DataAccessError.Insert_Error
                }
                print("registro creado en pivot table")
                return Int64(rowId)
            } catch _ {
                throw DataAccessError.Insert_Error
            }
            
            
            
        }
    }
    
    
    
    
    
    static func buscar(id: Int64) throws -> PGM? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(id == idgrupo)
        let grupos =  try DB.prepare(query)
        for gm in  grupos {
            return PivotGrupoMascaraModelo(
                idgrupo: gm[idgrupo],
                numeroMascara: gm[numeroMascara],
                idmascara0: gm[idmascara0],
                idmascara1 : gm[idmascara1],
                idmascara2 : gm[idmascara2],
                idmascara3 : gm[idmascara3],
                idmascara4 : gm[idmascara4],
                idmascara5 : gm[idmascara5],
                idmascara6 : gm[idmascara6],
                idmascara7 : gm[idmascara7],
                idmascara8 : gm[idmascara8],
                idmascara9 : gm[idmascara9],
                idmascara10 : gm[idmascara10],
                idmascara11 : gm[idmascara11],
                idmascara12 : gm[idmascara12],
                idmascara13 : gm[idmascara13],
                idmascara14 : gm[idmascara14],
                idmascara15 : gm[idmascara15],
                idmascara16 : gm[idmascara16],
                idmascara17 : gm[idmascara17],
                idmascara18 : gm[idmascara18],
                idmascara19 : gm[idmascara19],
                mascarapermiso0 : gm[mascaraPermiso0],
                mascarapermiso1 : gm[mascaraPermiso1],
                mascarapermiso2 : gm[mascaraPermiso2],
                mascarapermiso3 : gm[mascaraPermiso3],
                mascarapermiso4 : gm[mascaraPermiso4],
                mascarapermiso5 : gm[mascaraPermiso5],
                mascarapermiso6 : gm[mascaraPermiso6],
                mascarapermiso7 : gm[mascaraPermiso7],
                mascarapermiso8 : gm[mascaraPermiso8],
                mascarapermiso9 : gm[mascaraPermiso9],
                mascarapermiso10 : gm[mascaraPermiso10],
                mascarapermiso11 : gm[mascaraPermiso11],
                mascarapermiso12 : gm[mascaraPermiso12],
                mascarapermiso13 : gm[mascaraPermiso13],
                mascarapermiso14 : gm[mascaraPermiso14],
                mascarapermiso15 : gm[mascaraPermiso15],
                mascarapermiso16 : gm[mascaraPermiso16],
                mascarapermiso17 : gm[mascaraPermiso17],
                mascarapermiso18 : gm[mascaraPermiso18],
                mascarapermiso19 : gm[mascaraPermiso19]
            )
            
        }
        
        return nil
        
    }
    
    static func ver() throws -> [PGM]? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [PGM]()
        let gms = try DB.prepare(table)
        for gm in gms {
            retArray.append(PivotGrupoMascaraModelo(
                idgrupo: gm[idgrupo],
                numeroMascara: gm[numeroMascara],
                idmascara0: gm[idmascara0],
                idmascara1 : gm[idmascara1],
                idmascara2 : gm[idmascara2],
                idmascara3 : gm[idmascara3],
                idmascara4 : gm[idmascara4],
                idmascara5 : gm[idmascara5],
                idmascara6 : gm[idmascara6],
                idmascara7 : gm[idmascara7],
                idmascara8 : gm[idmascara8],
                idmascara9 : gm[idmascara9],
                idmascara10 : gm[idmascara10],
                idmascara11 : gm[idmascara11],
                idmascara12 : gm[idmascara12],
                idmascara13 : gm[idmascara13],
                idmascara14 : gm[idmascara14],
                idmascara15 : gm[idmascara15],
                idmascara16 : gm[idmascara16],
                idmascara17 : gm[idmascara17],
                idmascara18 : gm[idmascara18],
                idmascara19 : gm[idmascara19],
                mascarapermiso0 : gm[mascaraPermiso0],
                mascarapermiso1 : gm[mascaraPermiso1],
                mascarapermiso2 : gm[mascaraPermiso2],
                mascarapermiso3 : gm[mascaraPermiso3],
                mascarapermiso4 : gm[mascaraPermiso4],
                mascarapermiso5 : gm[mascaraPermiso5],
                mascarapermiso6 : gm[mascaraPermiso6],
                mascarapermiso7 : gm[mascaraPermiso7],
                mascarapermiso8 : gm[mascaraPermiso8],
                mascarapermiso9 : gm[mascaraPermiso9],
                mascarapermiso10 : gm[mascaraPermiso10],
                mascarapermiso11 : gm[mascaraPermiso11],
                mascarapermiso12 : gm[mascaraPermiso12],
                mascarapermiso13 : gm[mascaraPermiso13],
                mascarapermiso14 : gm[mascaraPermiso14],
                mascarapermiso15 : gm[mascaraPermiso15],
                mascarapermiso16 : gm[mascaraPermiso16],
                mascarapermiso17 : gm[mascaraPermiso17],
                mascarapermiso18 : gm[mascaraPermiso18],
                mascarapermiso19 : gm[mascaraPermiso19]

            ))
        }
        
        return retArray
        
    }
    
}
