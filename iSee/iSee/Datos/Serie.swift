//
//  Serie.swift
//  iSee
//
//  Created by Jose Antonio on 25/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Serie: NSObject,NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nombre, forKey: PropertyKey.nombre)
        aCoder.encode(foto, forKey: PropertyKey.foto)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(categoria, forKey: PropertyKey.categoria)
        aCoder.encode(temporadas, forKey: PropertyKey.temporadas)
        aCoder.encode(viendo, forKey: PropertyKey.viendo)
        aCoder.encode(terminada, forKey: PropertyKey.terminada)
    }
    
    static var DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchveURL: URL = DocumentDirectory.appendingPathComponent("series")
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let nom = aDecoder.decodeObject(forKey: PropertyKey.nombre) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        let f = aDecoder.decodeObject(forKey: PropertyKey.foto) as? UIImage
        let r = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        guard let c = aDecoder.decodeObject(forKey: PropertyKey.categoria) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        guard let t = aDecoder.decodeObject(forKey: PropertyKey.temporadas) as? [Temporada] else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        let vi = aDecoder.decodeBool(forKey: PropertyKey.viendo)
        let term = aDecoder.decodeBool(forKey: PropertyKey.terminada)
        
        self.init(nombre: nom, foto: f, rating: r , categoria: c, temporadas: t, viendo: vi , terminada: term)
    }
    
    var nombre: String
    var foto: UIImage?
    var rating: Int
    var categoria: String;
    var temporadas = [Temporada]();
    var viendo: Bool;
    var terminada: Bool;
    
    struct PropertyKey{
        static let nombre = "nombre";
        static let foto = "foto";
        static let rating = "rating";
        static let categoria = "categoria";
        static let temporadas = "temporada";
        static let viendo = "viendo";
        static let terminada = "terminada";
    }
    
    
    
    
    
    
    
    init?(nombre: String, foto: UIImage?,rating: Int,categoria: String,temporadas: [Temporada], viendo: Bool,terminada: Bool) {
        
        guard !nombre.isEmpty else{
            return nil;
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.nombre = nombre;
        self.foto = foto;
        self.rating = rating;
        self.categoria = categoria;
        self.temporadas = temporadas;
        self.viendo = viendo;
        self.terminada = terminada;
    }
}
