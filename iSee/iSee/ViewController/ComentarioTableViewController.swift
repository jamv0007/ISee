//
//  ComentarioTableViewController.swift
//  iSee
//
//  Created by Jose Antonio on 21/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class ComentarioTableViewController: UITableViewController,UIGestureRecognizerDelegate {

    var comentarios: [Comentario]?//Array de comentarios
    var ind: Int?//indice del capitulo
    var serie: Serie?//serie actual
    var temp: Temporada?//temporada actual
    var todasSeries: [Serie]?//todas las series
    
    var temAct: Int?;//temporada actual
    var serAct: Int?;//serie actual
    var capAct = -1;//capitulo actual
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se cambian los colores del status bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Añade Footer
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        
        //Cambia el titulo
        navigationItem.title = (serie?.nombre)! + " Temp " + String(temp!.numTemporada) + " Cap " + String(ind! + 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Añade el gesture recognizer
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        self.tableView.addGestureRecognizer(lpgr)
        
        //Se calcula el indice del capitulo
        for i in 0...todasSeries![serAct!].temporadas[temAct!].capitulos.count-1{
            if(todasSeries![serAct!].temporadas[temAct!].capitulos[i] === temp!.capitulos[ind!]){
                capAct = i;
            }
        }
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
    
    //Al mantener pulsado comentario
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            var cell = self.tableView.cellForRow(at: index)
            // do stuff with your cell, for example print the indexPath
            
            
            let sheet = UIAlertController(title: comentarios![index.row].usuario, message: nil, preferredStyle: .actionSheet)//Compartir comentario
            let compartir = UIAlertAction(title: "Compartir", style: .default) { (act) in
                let comp = UIAlertController(title: self.comentarios![index.row].usuario, message: "Escoge la opcion para compartir", preferredStyle: .actionSheet)
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
            }
            
            //eliminar comnetario
            let borrar = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                
                
                
                let alert = UIAlertController(title: "Eliminar elemento", message: "¿Seguro que quieres eliminar este elemento?", preferredStyle: .alert)
                let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                let aceptar = UIAlertAction(title: "Eliminar", style: .destructive, handler: { (action) in
                    
                    self.comentarios!.remove(at: index.row)
                    self.tableView.deleteRows(at: [index], with: .automatic)
                     self.todasSeries![self.serAct!].temporadas[self.temAct!].capitulos[self.capAct].comentarios.removeAll()
                    self.todasSeries![self.serAct!].temporadas[self.temAct!].capitulos[self.capAct].comentarios = self.comentarios!
                    self.save()
                    self.tableView.reloadData()
                })
                
                alert.addAction(cancelar)
                alert.addAction(aceptar)
                self.present(alert,animated: true,completion: nil)
            }
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            sheet.addAction(compartir)
            sheet.addAction(borrar)
            sheet.addAction(cancelar)
            
            sheet.view.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            present(sheet, animated: true, completion: nil)
            
        } else {
            print("Could not find index path")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (comentarios?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "coment"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ComentarioTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        
        
        // Configure the cell...
        let s = comentarios![indexPath.row]
        
        cell.usuario.text = s.usuario;
        cell.texto.text = s.textoComentario;

        return cell
    }


    //Al volver de añadir un nuevo comentario se crea uno con los datos rellenos
    @IBAction func unwindComentario(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ComentarioViewController, let cat: String = sourceViewController.texto.text {
            
            let tit = sourceViewController.titulo.text
            //Añadir comentario a la lista
            
            var comentario = Comentario(usuario: tit!, textoComentario: cat)
            
            comentarios?.append(comentario)
             self.todasSeries![self.serAct!].temporadas[self.temAct!].capitulos[self.capAct].comentarios.removeAll()
             self.todasSeries![self.serAct!].temporadas[self.temAct!].capitulos[self.capAct].comentarios = comentarios!
            self.save()
            tableView.reloadData()
            
        }
    }
    
    //Al cambiar de segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        if(segue.identifier == "nuevoComentario"){//si es un nuevo no hace nada
            print("Añadiendo comentario...")
            
        }else if(segue.identifier == "verComentario"){//Si es para verlo
            
            if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!){
            
                guard let DetailViewController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination")
                }
                guard let controlador = DetailViewController.viewControllers.first as? VerComentarioViewController else{
                    fatalError("Unexpected destination")
                }
                //manda los datos del comentario, titulo
                controlador.usu = comentarios![indexPath.row].usuario
                controlador.text = comentarios![indexPath.row].textoComentario
            }
        }else{
            print("Atras")
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
