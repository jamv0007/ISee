//
//  TemporadaTableViewController.swift
//  iSee
//
//  Created by Jose Antonio on 13/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class TemporadaTableViewController: UITableViewController {
    
    var temporada: [Temporada]? //temporadas
    var temp = [Temporada]() //temporadas
    var n = 0;//Numero de temporadas
    var al = UIAlertController()//Menu desplegable
    var antNcapitulos = [Int]();//Array con los capitulos antes de modificar,cada entero el el anterior de la temporada en esa posicion
    @IBOutlet weak var atr: UINavigationItem! //boton atras
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor(red:60/255,green:72/255,blue:88/255,alpha:255/255)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
         temp = temporada!
         for i in temp{//Cargan las temporadas de la serie
            
            antNcapitulos.append(i.numCapitulos)
            
            
         }
        
        
        
    }
    
    
//Boton añadir, añade una nueva al array
    @IBAction func add(_ sender: Any) {
        n=n+1
        var c = [Capitulo]();
        var t = Temporada(numTemporada: n, numCapitulos: 0, capitulos: c,viendo: false,fecha: "")
        temp.append(t)
        antNcapitulos.append(t.numCapitulos)
        tableView.reloadData()
    }
    
    
    //Al cambiar de segue al anterior vista, añadir una nueva serie
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        default://Se contabilizan los episodios y si es mayor el nuevo numero, añaden la diferencia
            for i in 0...temp.count-1{
                if(antNcapitulos[i] < temp[i].numCapitulos){
                    var dif = temp[i].numCapitulos - antNcapitulos[i]
                    for j in 0...dif-1{
                        var comen = [Comentario]();
                        var nuevo = Capitulo(numCap: j+1, comentarios: comen,visto: false)
                        temp[i].capitulos.append(nuevo)
                    }
                }else if(antNcapitulos[i] > temp[i].numCapitulos){//Si es menor se eliminan los sobrantes
                    
                    for i in antNcapitulos[i]-1...temp[i].numCapitulos{
                        temp[i].capitulos.remove(at: i)
                    }
                }
                
                print("Fecha " + String(i) + ": " + temp[i].fecha)
            }
            
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temp.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TemporadaTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TemporadaTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        

        // Configure the cell...
        let s = temp[indexPath.row]
        
        cell.nTemporada.text = String(s.numTemporada)
        cell.viendo.isOn = s.viendo;
        cell.nCapitulos = s.numCapitulos
        cell.recordatorio = s.fecha

        return cell
    }
    //Boton añadir capitulos
    @IBAction func addCapitulo(_ sender: UIButton) {
        var indx = IndexPath(row: 0, section: 0)
        for i in 0...temp.count-1{
            indx.row = i;//Se calula la celda y si se ha puldsado este boton de añadir
            if let celda = tableView.cellForRow(at: indx) as? TemporadaTableViewCell{
                if(celda.capitulos === sender){
                    let alert = UIAlertController(title: "Temporada " + celda.nTemporada.text!, message: "Numero de capitulos actual: " + String(celda.nCapitulos), preferredStyle: .alert)
                    alert.addTextField { (text) in
                        text.placeholder = "Nº de capitulos"
                        text.keyboardType = .numberPad//Despliega un alert para cambiar el numero
                    }
                    var hecho = true;
                    let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    let aceptar = UIAlertAction(title: "Aceptar", style: .default) { (action) in
                        if(!(alert.textFields?.first?.text?.isEmpty)!){
                            for i in (alert.textFields?.first?.text)!{//Comprueba que sea un numero
                                
                                if(String(i) != "0" && String(i) != "1" && String(i) != "2" && String(i) != "3" && String(i) != "4" && String(i) != "5" && String(i) != "6" && String(i) != "7" && String(i) != "8" && String(i) != "9"){
                                    
                                    hecho = false
                                    break
                                }
                            }
                            
                        }
                        
                        if(hecho == true){//se actualiza el numero
                            celda.nCapitulos = Int((alert.textFields?.first?.text)!)!
                            self.temp[indx.row].numCapitulos = celda.nCapitulos
                            
                        }else{
                            let novalido = UIAlertController(title: "Numero no valido", message: "El numero no es valido", preferredStyle: .alert)
                            let acep = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            novalido.addAction(acep)
                            self.present(novalido, animated: true)
                        }
                    }
                    
                    alert.addAction(cancelar)
                    alert.addAction(aceptar)
                    self.present(alert,animated: true);
                    break
                }
            }
        }
    }
    //Añadir fecha de salida, muestra un alert con date picker
    @IBAction func addRecordatorio(_ sender: UIButton) {
        var indx = IndexPath(row: 0, section: 0)
        for i in 0...temp.count-1{
            indx.row = i;
            if let celda = tableView.cellForRow(at: indx) as? TemporadaTableViewCell{
                if(celda.recordar === sender){
                    
                    al = UIAlertController(title: "Fecha para recordar", message: "Fecha actual: " + celda.recordatorio, preferredStyle: .alert)
                    
                    al.addTextField { (action) in
                        action.placeholder = "Indica la fecha"
                    }
                    
                    var date = UIDatePicker()
                    date.datePickerMode = .dateAndTime
                    date.addTarget(self, action: #selector(TemporadaTableViewController.dateChanged(datePicker:)), for: .valueChanged)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TemporadaTableViewController.viewTaped(gesture:)))
                    view.addGestureRecognizer(tapGesture)
                    
                    al.textFields?.first?.inputView = date
                    
                    let acep = UIAlertAction(title: "Aceptar", style: .default) { (act) in
                        celda.recordatorio = (self.al.textFields?.first?.text)!
                        self.temp[indx.row].fecha = celda.recordatorio
                        
                    }
                    let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    al.addAction(acep)
                    al.addAction(cancelar)
                    self.present(al, animated: true)
                    break
                }
                
                
                
            }
            
        }
    }
    //Elimina la ultima temporada añadida
    @IBAction func eliminar(_ sender: Any) {
        
        let advertir = UIAlertController(title: "Eliminar la ultima temporada añadida", message: "Se eliminará la ultima temporada añadida y los capitulos asociados", preferredStyle: .alert)
        let acpt = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
            self.temp.removeLast()
            self.antNcapitulos.removeLast()
            self.n = self.n - 1;
            self.tableView.reloadData()
        }
        
        let canc = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        advertir.addAction(acpt)
        advertir.addAction(canc)
        
        present(advertir,animated: true)
        
    }
    @objc func viewTaped(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    //coloca la fecha en el text area tras seleccionarla
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd/MM/yyyy-hh:mm"
        al.textFields?.first?.text = dateFormate.string(from: datePicker.date)
        view.endEditing(true)
        
    }
    //Cambiar el switch de viendo
    @IBAction func cambio(_ sender: UISwitch) {
        var indx = IndexPath(row: 0, section: 0)
        for i in 0...temp.count-1{
            indx.row = i;
            if let celda = tableView.cellForRow(at: indx) as? TemporadaTableViewCell{
                if(celda.viendo === sender){
                    temp[indx.row].viendo = celda.viendo.isOn
                    break;
                }
                
            }
        }
        
    }
    //Guardar y eliminar el ultimo
    
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
