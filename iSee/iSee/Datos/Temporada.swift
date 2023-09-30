//
//  Temporada.swift
//  iSee
//
//  Created by Jose Antonio on 25/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Temporada: NSObject, NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numTemporada, forKey: PropertyKey.numTemporada)
        aCoder.encode(numCapitulos, forKey: PropertyKey.numCapitulos)
        aCoder.encode(capitulos, forKey: PropertyKey.capitulos)
        aCoder.encode(viendo, forKey: PropertyKey.viendo)
        aCoder.encode(fecha, forKey: PropertyKey.fecha)
        
    }
    
    static var DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchveURL: URL = DocumentDirectory.appendingPathComponent("temporadas")
    
    required convenience init?(coder aDecoder: NSCoder) {
        let nt = aDecoder.decodeInteger(forKey: PropertyKey.numTemporada)
        let nc = aDecoder.decodeInteger(forKey: PropertyKey.numCapitulos)
        guard let cap = aDecoder.decodeObject(forKey: PropertyKey.capitulos) as? [Capitulo] else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        let v = aDecoder.decodeBool(forKey: PropertyKey.viendo)
        guard let f = aDecoder.decodeObject(forKey: PropertyKey.fecha) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        
        self.init(numTemporada: nt , numCapitulos: nc, capitulos: cap, viendo: v , fecha: f)
    }
    
    struct PropertyKey{
        static let numTemporada = "numtemporada";
        static let numCapitulos = "numCapitulo";
        static let capitulos = "capitulos";
        static let viendo = "viendo";
        static let fecha = "fecha";
    }
    
    var numTemporada: Int;
    var numCapitulos: Int;
    var capitulos = [Capitulo]();
    var viendo: Bool;
    var fecha: String
    
    init(numTemporada: Int, numCapitulos: Int, capitulos: [Capitulo],viendo: Bool,fecha: String) {
        self.numTemporada = numTemporada;
        self.numCapitulos = numCapitulos;
        self.capitulos = capitulos;
        self.viendo = viendo;
        self.fecha = fecha;
    }
}
