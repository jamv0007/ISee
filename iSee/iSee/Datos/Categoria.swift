//
//  Categoria.swift
//  iSee
//
//  Created by Jose Antonio on 4/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Categoria: NSObject, NSCoding{
    var nombre: String
    var foto: UIImage?
    
    struct PropertyKey{
        static let nombre = "nombre";
        static let foto = "foto";
       
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nombre, forKey: PropertyKey.nombre)
        aCoder.encode(foto, forKey: PropertyKey.foto)
        
    }
    
    static var DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchveURL: URL = DocumentDirectory.appendingPathComponent("categorias")
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let nom = aDecoder.decodeObject(forKey: PropertyKey.nombre) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        let f = aDecoder.decodeObject(forKey: PropertyKey.foto) as? UIImage
        
        
        self.init(nombre: nom, foto: f)
    }
    
    init?(nombre: String, foto: UIImage?) {
        guard !nombre.isEmpty else {
            return nil
        }
        
        self.nombre = nombre;
        self.foto = foto;
        
        
    }
}
