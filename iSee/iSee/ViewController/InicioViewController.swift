//
//  InicioViewController.swift
//  iSee
//
//  Created by Jose Antonio on 24/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class InicioViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var indice = -1;
    
    var seriesViendo = [Serie]();//Todas las series que se estan viendo ahora
    var todasSeries = [Serie]();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cambio del color del texto de la barra de de estado
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Añadir un footer a la tabla de forma que no muestre celdas vacias
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        // Do any additional setup after loading the view.
    }
    
    //Cuando aparezca la vista añadir a la tabla solo las que esten marcadas como viendo y no terminadas
    override func viewWillAppear(_ animated: Bool) {
        seriesViendo.removeAll()
        todasSeries.removeAll()
        
        let tabBar = tabBarController as? TabViewController
        todasSeries = (tabBar?.series)!
        for i in (tabBar?.series)!{
            if(i.viendo == true && i.terminada == false){
                seriesViendo.append(i);
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return seriesViendo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "inicioCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InicioTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let serie = seriesViendo[indexPath.row]
        
        
        cell.nombre.text = serie.nombre
        cell.img.image = serie.foto
        
        cell.puntuacion.text = String(serie.rating)
        cell.icono.image = UIImage(named: "empty")
        cell.categoria.text = serie.categoria
        
        //Calculamos la temporada actual marcada como viendo
        var tmpAct = 0;
        var cont = 0;
        for i in serie.temporadas{
            if(i.viendo == true){
                tmpAct = cont + 1;
            }
            cont = cont + 1;
        }
        //Lo mismo con los capitulos
        cont = 0;
        var capAct = 0;
        
        if(tmpAct != 0){
            for i in serie.temporadas[tmpAct-1].capitulos{
                if(i.visto == true){
                    capAct = cont + 1;
                }
                cont = cont + 1;
            }
        }
        
        //Segun lo calculado cambiamos el label por la que se necesite
        if(tmpAct == 0){
            cell.actual.text = "Ninguna"
        }else{
            if(capAct == 0){
                cell.actual.text = "Temp " + String(tmpAct)
            }else{
                cell.actual.text = "Temp " + String(tmpAct) + " Cap " + String(capAct)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indice = indexPath.row
        print("Hola")
        self.performSegue(withIdentifier: "verInicioSerie", sender: self)
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
