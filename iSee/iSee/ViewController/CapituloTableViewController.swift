//
//  CapituloTableViewController.swift
//  iSee
//
//  Created by Jose Antonio on 20/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class CapituloTableViewController: UITableViewController,UISearchBarDelegate {
    
    var capitulos: [Capitulo]?//capitulos
    var copCapitulo: [Capitulo]?//Copia de los capitulos
    var todasSeries: [Serie]?//todas las series
    var serie: Serie?//serie actual
    var ind: Int?//indice de las temporadas
    
    var temAct = -1;//Temporada actual
    var serAct = -1;//indice de la serie
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Se cambia el color de la barra de estado
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Se añade un footer
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        
        //Se cambia el titulo
        navigationItem.title = (serie?.nombre)! + " Temporada " + String(ind! + 1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        copCapitulo = capitulos
        //se actualizan los indices de serie actual y temporada actual
        for i in 0...(todasSeries?.count)!-1{
            if(todasSeries![i] === serie){
                serAct = i;
                for j in 0...todasSeries![i].temporadas.count-1{
                    if(todasSeries![i].temporadas[j] === serie?.temporadas[ind!]){
                        temAct = j;
                        break
                    }
                }
                break
            }
        }
    }
    
    //Funcion para guardar las series
    private func save(){
        let guardadoCorrecto = NSKeyedArchiver.archiveRootObject(todasSeries, toFile: Serie.ArchveURL.path)
        
        if guardadoCorrecto {
            os_log("Guardados",log: OSLog.default, type: .debug)
        }else{
            os_log("No guardados",log: OSLog.default, type: .error)
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (capitulos?.count)!
    }
    //Al cambiar el switch del episodio se actualizan
    @IBAction func marcar(_ sender: UISwitch) {
        var indx = IndexPath(row: 0, section: 0)
        for i in 0...capitulos!.count-1{
            indx.row = i;
            if let celda = tableView.cellForRow(at: indx) as? CapituloTableViewCell{
                if(celda.visto === sender){
                    capitulos![indx.row].visto = celda.visto.isOn
                    break;
                }
                
            }
        }
        var cont = 0;
        for i in copCapitulo!{
            if(i === capitulos![indx.row]){
                copCapitulo![cont].visto = capitulos![indx.row].visto
                break;
            }
            cont = cont + 1;
        }
        todasSeries![serAct].temporadas[temAct].capitulos.removeAll()
        todasSeries![serAct].temporadas[temAct].capitulos = copCapitulo!
        save()
        
    }
    //Al pulsar el boton de info muestra el accionSheet con el numero de capitulos y la fecha de salida
    @IBAction func info(_ sender: UIBarButtonItem) {
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let aux = "Fecha de estreno de la temporada: " + serie!.temporadas[ind!].fecha + "\n" + "Numero de capitulos: " + String(serie!.temporadas[ind!].numCapitulos)
        let titleAttrString = NSMutableAttributedString(string: aux, attributes: titleFont)
        let informacion = UIAlertController(title: navigationItem.title, message: nil, preferredStyle: .actionSheet)
        
        informacion.setValue(titleAttrString, forKey:"attributedMessage")
        
        let aceptar = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
        
        informacion.addAction(aceptar)
        
        present(informacion,animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cap"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CapituloTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        
        
        // Configure the cell...
        let s = capitulos![indexPath.row]
        
        cell.numero.text = String(s.numCap);
        cell.visto.isOn = s.visto
        
        return cell

    }
    //Barra de busqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        capitulos?.removeAll()
        for i in copCapitulo!{
            if(String(i.numCap).lowercased().contains(searchBar.text!.lowercased())){
                capitulos?.append(i)
            }
        }
        
        if(searchBar.text!.isEmpty){
            capitulos = copCapitulo
        }
        
        self.tableView.reloadData();
    }
    
    //Preparacion para la vista de comentarios
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "comentarios":
            if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
                guard let DetailViewController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination")
                }
                guard let controlador = DetailViewController.viewControllers.first as? ComentarioTableViewController else{
                    fatalError("Unexpected destination")
                }
                
                controlador.serie = serie
                controlador.todasSeries = todasSeries
                controlador.serAct = serAct
                controlador.temAct = temAct
                controlador.comentarios = capitulos![indexPath.row].comentarios
                controlador.ind = indexPath.row
                controlador.temp = serie?.temporadas[self.ind!]
            }
            
        default:
            capitulos?.removeAll()
            capitulos = copCapitulo
        }
        
    }
    //Al venir de comentarios
    @IBAction func unwindAddVerComentarios(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ComentarioTableViewController, let cat: [Comentario] = sourceViewController.comentarios {
            
            //Añadir comentario a la lista
            
            capitulos![sourceViewController.ind!].comentarios = cat
            var cont = 0;
            for i in copCapitulo!{
                if(i === capitulos![sourceViewController.ind!]){
                    copCapitulo![cont].comentarios = cat;
                }
                
                cont = cont + 1;
            }
            
            todasSeries![serAct].temporadas[temAct].capitulos.removeAll()
            todasSeries![serAct].temporadas[temAct].capitulos = copCapitulo!
            save()
            
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
