//
//  Capitulo.swift
//  iSee
//
//  Created by Jose Antonio on 25/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Capitulo: NSObject,NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numCap, forKey: key.numCap)
        aCoder.encode(visto, forKey: key.visto)
        aCoder.encode(comentarios, forKey: key.comentarios)
        
    }
    
    static var DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchveURL: URL = DocumentDirectory.appendingPathComponent("capitulos")
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let nc = aDecoder.decodeInteger(forKey: key.numCap)
        let v = aDecoder.decodeBool(forKey: key.visto)
        guard let com = aDecoder.decodeObject(forKey: key.comentarios) as? [Comentario] else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(numCap: nc, comentarios: com, visto: v)
    }
    
    struct key{
        static let numCap = "numcap";
        static let visto = "visto";
        static let comentarios = "comentarios";
    }
    
    var numCap: Int = 0;
    var visto: Bool;
    var comentarios = [Comentario]();
    
    init(numCap: Int,comentarios: [Comentario],visto: Bool) {
        self.numCap = numCap;
        self.comentarios = comentarios;
        self.visto = visto;
    }
}
