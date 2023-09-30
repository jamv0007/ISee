//
//  CategoriaListaViewController.swift
//  iSee
//
//  Created by Jose Antonio on 10/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class CategoriaListaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate {
    

    @IBOutlet weak var tableView: UITableView!//Table view
    @IBOutlet weak var btnOrden: UIButton!//Boton para ordenar
    
    var todasSeries: [Serie]?;//Todas las series
    var series: [Serie]?;//Series de esta categoria pulsada
    var serCopia = [Serie]();//Copia para ordenacion y busqueda
    var estado = 0//Estado ordenacion
    var categoria: Categoria?//Categoria
    var indice: Int = -1//Indice para modificar
    
    //Funcion orden para ordenar alfabeticamente
    @IBAction func orden(_ sender: Any) {
        let az = UIImage.init(named: "az")
        let za = UIImage.init(named: "za")
        let norm = UIImage.init(named: "normal")
        
        //Si se va a ordenar se restablece el color de la celda de la serie marcada como terminada
        var index = IndexPath(row: 0, section: 0);
        for i in 0...tableView.numberOfRows(inSection: 0)-1{
            index.row = i;
            let cell = tableView.cellForRow(at: index)
            cell?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        }
        
        //Segun el estado se ordena
        if(estado == 0){
            btnOrden.setImage(za, for: .normal)
            estado = estado + 1;
            ordenaz()
        }else if(estado == 1){
            
            btnOrden.setImage(norm, for: .normal)
            estado = estado + 1;
            ordenza()
        }else if(estado == 2){
            
            btnOrden.setImage(az, for: .normal)
            estado = 0;
            normal()
        }
    }
    
    func ordenaz(){
        series!.sort { (a: Serie, b:Serie) -> Bool in
            
            return a.nombre < b.nombre
            
        }
        self.tableView.reloadData()
        
    }
    
    func ordenza(){
        
        series!.sort { (a: Serie, b:Serie) -> Bool in
            
            return a.nombre > b.nombre
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func normal(){
        series!.removeAll()
        series = serCopia
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cambia el color de la barra de estado
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
        
        //Añade el pie a la tabla
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        
        //estado actual
        let az = UIImage.init(named: "az")
        btnOrden.setImage(az, for: .normal)
        
        //se cambia el titulo de la barra de navegacion por el de la categoria
        if let actualiza = categoria{
            navigationItem.title = actualiza.nombre
        }
        
        //Se implementa el longgesture recognizer para el menu
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        self.tableView.addGestureRecognizer(lpgr)
        
        //Se cargan solo las series de todas cuya categoria sea la actual
        for i in todasSeries!{
            if(i.categoria == categoria?.nombre){
                serCopia.append(i)
            }
        }
        
        series = serCopia;
    }
    
    //Al pulsar el gesture se abre un accionsheet
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            var cell = self.tableView.cellForRow(at: index)
            // do stuff with your cell, for example print the indexPath
            
            //Compartir,solo estetica
            let sheet = UIAlertController(title: series![index.row].nombre, message: nil, preferredStyle: .actionSheet)
            let compartir = UIAlertAction(title: "Compartir", style: .default) { (act) in
                let comp = UIAlertController(title: self.series![index.row].nombre, message: "Escoge la opcion para compartir", preferredStyle: .actionSheet)
                let ca = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                let whas = UIAlertAction(title: "WhatsApp", style: .default, handler: nil)
                let ins = UIAlertAction(title: "Instagram", style: .default, handler: nil)
                let face = UIAlertAction(title: "Facebook", style: .default, handler: nil)
                
                var w = UIImage(named: "wha")
                var f = UIImage(named: "face")
                var inst = UIImage(named: "insta")
                whas.setValue(w, forKey: "image")
                ins.setValue(inst, forKey: "image")
                face.setValue(f, forKey: "image")
                
                comp.addAction(whas)
                comp.addAction(ins)
                comp.addAction(face)
                comp.addAction(ca)
                self.present(comp,animated: true)
            }//Editar
            let editar = UIAlertAction(title: "Editar", style: .default) { (action) in
                self.indice = index.row
                self.segueEdicion(nil);
            }//Marcar como terminada, la celda cambia de color
            let terminado = UIAlertAction(title: "Marcar como terminada", style: .default) { (accion) in
                if(self.series![index.row].terminada){
                    let color:UIColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
                    cell?.backgroundColor = color
                    self.series![index.row].terminada = false
                }else{
                    cell?.backgroundColor = UIColor(red: 52/255, green: 95/255, blue: 118/255, alpha: 1)
                    self.series![index.row].terminada = true
                }
            }//Borrar
            let borrar = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                
                
                
                let alert = UIAlertController(title: "Eliminar elemento", message: "¿Seguro que quieres eliminar este elemento?", preferredStyle: .alert)
                let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                let aceptar = UIAlertAction(title: "Eliminar", style: .destructive, handler: { (action) in
                    for i in 0...self.serCopia.count-1{
                        if(self.serCopia[i] === self.series![index.row]){
                            self.serCopia.remove(at: i)
                            break;
                        }
                    }
                    self.series!.remove(at: index.row)
                    let aux = self.todasSeries
                    self.todasSeries?.removeAll()
                    for i in aux!{
                        if(i.categoria != self.categoria?.nombre){
                            self.todasSeries?.append(i)
                        }
                    }//Se elimina y se cargan todas de nuevo excepto esa
                    self.todasSeries! += self.serCopia
                    self.save()
                    self.tableView.deleteRows(at: [index], with: .automatic)
                    self.tableView.reloadData()
                })
                
                alert.addAction(cancelar)
                alert.addAction(aceptar)
                self.present(alert,animated: true,completion: nil)
            }
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            sheet.addAction(editar)
            sheet.addAction(compartir)
            sheet.addAction(terminado)
            sheet.addAction(borrar)
            sheet.addAction(cancelar)
            
            sheet.view.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            present(sheet, animated: true, completion: nil)
            
        } else {
            print("Could not find index path")
        }
    }
    

    //Segue artificial
    @IBAction func segueEdicion(_ sender: Any?) {
        self.performSegue(withIdentifier: "modificarElemento", sender: self)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return series!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CategoriaListaTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoriaListaTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let serie = series![indexPath.row]
        
        cell.nombre.text = serie.nombre
        cell.img.image = serie.foto
        
        cell.rating.text = String(serie.rating)
        cell.icoRating.image = UIImage(named: "empty")
        cell.viendo.isOn = serie.viendo
        
        //Si esta terminada se cambia el color de la celda
        if(serie.terminada){
            cell.backgroundColor = UIColor(red: 52/255, green: 95/255, blue: 118/255, alpha: 1)
        }
    //Se calcula por donde va actualmente
        var tmpAct = 0;
        var cont = 0;
        for i in serie.temporadas{
            if(i.viendo == true){
                tmpAct = cont + 1;
            }
            cont = cont + 1;
        }
        
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
    //Flecha hacia atras
    @IBAction func atras(_ sender: UIBarButtonItem) {
       
        dismiss(animated: true, completion: nil)
            
        
    }
    //barra de busqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        series!.removeAll()
        for i in serCopia{
            if(i.nombre.lowercased().contains(searchBar.text!.lowercased())){
                series!.append(i)
            }
        }
        
        if(searchBar.text!.isEmpty){
            series = serCopia
        }
        
        self.tableView.reloadData();
    }
    
    //Preparacion para cambio de vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "addElemento":
            guard let DetailViewController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination")
            }
            guard let controlador = DetailViewController.viewControllers.first as? AddElementoViewController else{
                fatalError("Unexpected destination")
            }
            
            controlador.categoria = (self.categoria?.nombre)!
            controlador.segue = segue.identifier
        case "modificarElemento":
            guard let DetailViewController = segue.destination as? AddElementoViewController else{
                fatalError("Unexpected destination")
            }
            
            DetailViewController.categoria = (self.categoria?.nombre)!
            let selected = series![indice]
            DetailViewController.serie = selected
            DetailViewController.segue = segue.identifier
            DetailViewController.temp = series![indice].temporadas
        case "verElemento":
            if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
                guard let DetailViewController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination")
                }
                guard let controlador = DetailViewController.viewControllers.first as? ListaTempViewController else{
                    fatalError("Unexpected destination")
                }
                
                controlador.todasSeries = todasSeries
                controlador.serie = series![indexPath.row]
                controlador.temporadas = series![indexPath.row].temporadas
                controlador.ind = indexPath.row
            }
        default:
            print("Atras");
        }
        
    }
    //Volver de ver el contenido de una serie
    @IBAction func unwindTemporadaVer(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ListaTempViewController, let cat: [Temporada] = sourceViewController.temporadas {
            
            //Se cambian las temporadas y se actualizan todas la series
            let se = sourceViewController.ind
            self.series![se!].temporadas = cat;
            var cont = 0;
            for i in serCopia{
                if(i === series![se!]){
                    serCopia[cont].temporadas = cat
                }
                cont = cont + 1;
            }
            
            
            tableView.reloadData()
            todasSeries!.removeAll()
            todasSeries! = sourceViewController.todasSeries!
            save()
            
            
        }
    }
    
    //Cuando viene de añadir
    @IBAction func unwindElementoAdd(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddElementoViewController, let cat = sourceViewController.serie{
            //modificar
            if(indice != -1){
                for i in 0...serCopia.count-1{
                    if(serCopia[i] === series![indice]){
                        serCopia[i] = cat
                    }
                }
                series![indice] = cat
                let aux = todasSeries
                todasSeries?.removeAll()
                for i in aux!{
                    if(i.categoria != self.categoria?.nombre){
                        todasSeries?.append(i)
                    }
                }
                todasSeries! += serCopia
                tableView.reloadData()
                indice = -1
            }else{//add una nueva
                series!.removeAll()
                serCopia.append(cat)
                series = serCopia
                let aux = todasSeries
                todasSeries?.removeAll()
                for i in aux!{
                    if(i.categoria != self.categoria?.nombre){
                        todasSeries?.append(i)
                    }
                }
                todasSeries! += serCopia
                
                tableView.reloadData()
            }
            
            save()
        }
    }
    //Al cambiar el switch de la celda se actualizan los arrrays y todas las series
    @IBAction func cambiarEstado(_ sender: UISwitch) {
        var inx = IndexPath(row: 0, section: 0)
        for i in 0...serCopia.count-1{
            inx.row = i
            if let celda = tableView.cellForRow(at: inx) as? CategoriaListaTableViewCell{
                if(celda.viendo === sender){
                    if(serCopia[i].viendo){
                        serCopia[i].viendo = false
                    }else{
                        serCopia[i].viendo = true
                    }
                    for j in 0...serCopia.count-1{
                        if(serCopia[i] === series![j]){
                            series![j].viendo = serCopia[i].viendo
                            break
                        }
                    }
                    break
                }
            }
        }
        
        let aux = todasSeries
        todasSeries?.removeAll()
        for i in aux!{
            if(i.categoria != self.categoria?.nombre){
                todasSeries?.append(i)
            }
        }
        todasSeries! += serCopia
        
        save()
    }
    
    //Guardar las series
    private func save(){
        let guardadoCorrecto = NSKeyedArchiver.archiveRootObject(todasSeries, toFile: Serie.ArchveURL.path)
        
        if guardadoCorrecto {
            os_log("Guardados",log: OSLog.default, type: .debug)
        }else{
            os_log("No guardados",log: OSLog.default, type: .error)
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
