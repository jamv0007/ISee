//
//  Comentario.swift
//  iSee
//
//  Created by Jose Antonio on 21/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Comentario: NSObject,NSCoding {
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(usuario, forKey: comentarios.usuario)
        aCoder.encode(textoComentario, forKey: comentarios.textoComentario)
        
    }
    
    static var DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchveURL: URL = DocumentDirectory.appendingPathComponent("comentarios")
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let t = aDecoder.decodeObject(forKey: comentarios.usuario) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let text = aDecoder.decodeObject(forKey: comentarios.textoComentario) as? String else{
            os_log("No se puede decodificar", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(usuario: t, textoComentario: text)
        
    }
    
    struct comentarios{
        static let usuario = "usuario";
        static let textoComentario = "textocomentario";
    }
    
    var usuario: String;
    var textoComentario: String;
    
    init(usuario: String, textoComentario: String) {
        self.usuario = usuario;
        self.textoComentario = textoComentario;
    }
}
