//
//  ListaTempViewController.swift
//  iSee
//
//  Created by Jose Antonio on 19/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class ListaTempViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var img: UIImageView! //Referencia a la imagen
    @IBOutlet weak var listaTemp: UITableView! //Referencia a la table view
    
    var temporadas: [Temporada]? //Todas las temporadas de la serie pulsada
    var todasSeries: [Serie]? //Todas las series
    var serie: Serie? //Serie actual
    var temCopia = [Temporada](); //Copia de las temporadas
    var ind: Int?; //indice de la serie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cambian los colores de la barra de estado
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //Footer de la tabla
        listaTemp.tableFooterView = UIView()
        listaTemp.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        //Titulo de la vista
        navigationItem.title = serie?.nombre
        img.image = serie?.foto
        
        temCopia = temporadas!;
        
        // Do any additional setup after loading the view.
    }
    
    //Funcion guardar
    private func save(){
        let guardadoCorrecto = NSKeyedArchiver.archiveRootObject(todasSeries, toFile: Serie.ArchveURL.path)
        
        if guardadoCorrecto {
            os_log("Guardados",log: OSLog.default, type: .debug)
        }else{
            os_log("No guardados",log: OSLog.default, type: .error)
        }
    }
    //Al cambiar el switch de la temporada
    @IBAction func cambiarSwitch(_ sender: UISwitch) {
        var indx = IndexPath(row: 0, section: 0)
        for i in 0...temporadas!.count-1{
            indx.row = i;//Se detecta el que se ha pulsado
            if let celda = listaTemp.cellForRow(at: indx) as? ListaTempTableViewCell{
                if(celda.viendo === sender){
                    temporadas![indx.row].viendo = celda.viendo.isOn
                    break;
                }
                
            }
        }
        var cont = 0;
        for i in temCopia{//se actualiza la copia de la temporada
            if(i === temporadas![indx.row]){
                temCopia[cont].viendo = temporadas![indx.row].viendo
                break;
            }
            cont = cont + 1;
        }
        
        //Se actualizan todas las series
        for i in 0...(todasSeries?.count)!-1{
            if(todasSeries![i] === serie){
                todasSeries![i].temporadas.removeAll()
                todasSeries![i].temporadas = temCopia
                break;
            }
        }

        save()
    }
    
    //Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        temporadas?.removeAll()
        for i in temCopia{
            if(String(i.numTemporada).lowercased().contains(searchBar.text!.lowercased())){
                temporadas?.append(i)
            }
        }
        
        if(searchBar.text!.isEmpty){
            temporadas = temCopia
        }
        
        self.listaTemp.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temporadas!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "te"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListaTempTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let tem = temporadas![indexPath.row]
        
        cell.viendo.isOn = tem.viendo
        cell.numero.text = String(indexPath.row+1)
        
        
        return cell
    }
    
    //Viene de inicio
    @IBAction func unwindInicio(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? InicioViewController{
            self.todasSeries = sourceViewController.todasSeries
            
            self.temporadas = sourceViewController.seriesViendo[sourceViewController.indice].temporadas
            self.serie = sourceViewController.seriesViendo[sourceViewController.indice]
            self.temCopia = self.temporadas!
            
            for i in 0...(todasSeries?.count)!-1{
                if(todasSeries![i] === self.serie){
                    self.ind = i;
                    break;
                }
            }
            
            
        }
    }
    
    //Al volver de ver los capitulos se actualizan los capitulos de la temporada y las series
    @IBAction func unwindCapitulo(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CapituloTableViewController, let cat: [Capitulo] = sourceViewController.capitulos {
            
            let se = sourceViewController.ind
            self.temporadas![se!].capitulos = cat;
            var cont = 0;
            for i in temCopia{
                if(i === temporadas![se!]){
                    temCopia[cont].capitulos = cat
                }
                cont = cont + 1;
            }
            
            for i in 0...(todasSeries?.count)!-1{
                if(todasSeries![i] === serie){
                    todasSeries![i].temporadas.removeAll()
                    todasSeries![i].temporadas = temCopia
                    break;
                }
            }
            
            save()
            
        }
    }
    //Al ir a ver los capitulos de esa temporada
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {

        case "verCapitulos":
            if let indexPath = listaTemp.indexPath(for: (sender as? UITableViewCell)!){
                guard let DetailViewController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination")
                }
                guard let controlador = DetailViewController.viewControllers.first as? CapituloTableViewController else{
                    fatalError("Unexpected destination")
                }
                
                controlador.serie = serie//Serie actual
                controlador.todasSeries = todasSeries//todas las series
                controlador.capitulos = temporadas![indexPath.row].capitulos//la lista de capitulos de la serie actual
                controlador.ind = indexPath.row//el indice de la temporada
            }
        
            
        default:
            temporadas?.removeAll()
            temporadas = temCopia
            
        }
        
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
