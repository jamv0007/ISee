//
//  TabBarViewController.swift
//  ProyectoDM
//
//  Created by Jose Antonio on 24/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    var series = [Serie]();//Todas las series que hay guardadas

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Si se puede se cargan los datos almacenados
        
        if let saved = load() {
            series += saved
        }else{
            loadSample()
        }
    
    }
    
    
    
    
    //Esta funcion permite cargar series de ejemplo con todo su contenido
    func loadSample(){
        //Crean las temporadas y capitulos
        var temp = [Temporada]();
        var cp = [Capitulo]();
        for i in 0...959{
            let com = [Comentario]();
            let nu = Capitulo(numCap: i+1, comentarios: com,visto: true)
            cp.append(nu);
        }
        let t1 = Temporada(numTemporada: 1, numCapitulos: 960, capitulos: cp, viendo: true, fecha: "19/04/2021-06:13");
        temp.append(t1);
        
        
        var temp2 = [Temporada]();
        var cap2 = [Capitulo]();
        for i in 0...23{
            let com = [Comentario]()
            let cap22 = Capitulo(numCap: i+1, comentarios: com, visto: true)
            cap2.append(cap22)
        }
        let nueva = Temporada(numTemporada: 1, numCapitulos: 24, capitulos: cap2, viendo: true, fecha: "19/04/2021-06:13")
        temp2.append(nueva)
        
        
        let temp3 = [Temporada]();
        let temp4 = [Temporada]();
        
        
        //Creamos los objetos de las series
        let one = UIImage(named: "onepiece")
        let tate = UIImage(named: "tate")
        let got = UIImage(named: "gotham")
        let end = UIImage(named: "endgame")
        guard let p1 = Serie(nombre: "One piece", foto: one, rating: 4, categoria: "Anime", temporadas: temp,viendo: true,terminada: false) else{
            fatalError("No se ha podido cargar")
        }
        guard let p2 = Serie(nombre: "Tate no Yuusa", foto: tate, rating: 5, categoria: "Anime", temporadas: temp2,viendo: true, terminada: true) else{
            fatalError("No se ha podido cargar")
        }
        
        guard let p3 = Serie(nombre: "Vengadores Endgame", foto: end, rating: 5, categoria: "Peliculas", temporadas: temp3,viendo: false, terminada: false) else{
            fatalError("No se ha podido cargar")
        }
        guard let p4 = Serie(nombre: "Gotham", foto: got, rating: 4, categoria: "Series", temporadas: temp4,viendo: true, terminada: false) else{
            fatalError("No se ha podido cargar")
        }
        
        //Se cargan
        var ejemplos = [Serie]();
        ejemplos += [p1,p2,p3,p4]
        
        
        series = ejemplos
        
        
        
    }
    
    //Funcion para cargar los datos con la persistencia
    private func load() -> [Serie]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Serie.ArchveURL.path) as? [Serie]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
