//
//  CategoriasViewController.swift
//  iSee
//
//  Created by Jose Antonio on 25/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log
class CategoriasViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate{
    
    var serie = [Serie]()//Series actuales
    var categorias = [Categoria]() //Todas la categorias
    var catCopia = [Categoria](); //Copia de las categorias para ordenacion y busqueda
    var estado = 0;//En que ordenacion estamos, 0 como se inserto, 1 alfabetica descendente, 2 alfabetica ascendente
    var indice = -1;//indice de la fila pulsada al editar una categoria
    var origen = 0;//Indica con 0 que venimos de la vista del tabbar o 1 si venimos de añadir u mostrar
    var nombreAnt = ""
    
    //Colllection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Funcion de carga de las categorias
    public func loadSampleCategorias(){
        let Anime = UIImage(named: "Anime")
        let Series = UIImage(named: "Series")
        let Peliculas = UIImage(named: "Peliculas")
        
        guard let c1 = Categoria(nombre: "Anime", foto: Anime) else{
            fatalError("No se puede cargar");
        }
        guard let c2 = Categoria(nombre: "Series", foto: Series) else{
            fatalError("No se puede cargar");
        }
        guard let c3 = Categoria(nombre: "Peliculas", foto: Peliculas) else{
            fatalError("No se puede cargar");
        }
        
        
        
        categorias+=[c1,c2,c3]
            
        catCopia = categorias
        
        
    }

    //Funcion que se ejecuta al cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cambiamos los colores de la barra de estado
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
        
        //Inicializamos la ordenacion
        let az = UIImage.init(named: "az")
        btnOrden.setImage(az, for: .normal)
        
        //Se crea el gesto de mantener presionado
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
        
        //Se cargan los datos si hace falta
        if let carga = load(){

            categorias += carga
            catCopia = categorias
            
        }else{
        
            loadSampleCategorias()
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorias.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath) as! CategoriaCollectionViewCell
        
        cell.name.text = categorias[indexPath.item].nombre
        cell.img.image = categorias[indexPath.item].foto
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoriaSearch", for: indexPath)
        
        return searchView;
    }
    

    //Funcion de la barra de busqueda
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categorias.removeAll()
        for i in catCopia{
            if(i.nombre.lowercased().contains(searchBar.text!.lowercased())){
                categorias.append(i)
            }
        }
        
        if(searchBar.text!.isEmpty){
            categorias = catCopia
        }
        
        self.collectionView.reloadData();
    }
    
    //Boton de orden
    @IBOutlet weak var btnOrden: UIButton!
    //Funcion filtro al pulsar el boton, cambia de estado
    @IBAction func filtro(_ sender: Any) {
        let az = UIImage.init(named: "az")
        let za = UIImage.init(named: "za")
        let norm = UIImage.init(named: "normal")
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
    
    //Funcion de ordenacion de la a a z
    func ordenaz(){
        categorias.sort { (a: Categoria, b:Categoria) -> Bool in
            
            return a.nombre < b.nombre
            
        }
        self.collectionView.reloadData()
        
    }
    //Funcion de ordenacion de la z a la a
    func ordenza(){
        
        categorias.sort { (a: Categoria, b:Categoria) -> Bool in
            
            return a.nombre > b.nombre
            
        }
        
        self.collectionView.reloadData()
        
    }
    //Lo ordena como se insertaron
    func normal(){
        categorias.removeAll()
        categorias = catCopia
        self.collectionView.reloadData()
    }
    //Boton para crear un segue artificial, el boton no se puede pulsar en la interfaz
    @IBAction func boton(_ sender: Any?) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    //LLamada de unwind de añadir, modificar y ver
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddCategoriaViewController, let cat = sourceViewController.categoria {
            
            //Se recogen los datos de una categoria actualizada
            if (indice != -1) {
                
                
                
                for i in 0...catCopia.count-1{
                    if(catCopia[i] === categorias[indice]){
                        catCopia[i] = cat
                    }
                }
                categorias[indice] = cat
                for i in 0...serie.count-1{
                    if(serie[i].categoria == nombreAnt){
                        serie[i].categoria = cat.nombre
                    }
                }
                save()
                nombreAnt = ""
                savecat()
                collectionView.reloadData()
                indice = -1
                
            }
            else{//Insertar nueva categoria
                estado = 0
                categorias.removeAll()
                categorias = catCopia
                categorias.append(cat)
                catCopia.append(cat)
                // Add a new meal.
                let newIndexPath = IndexPath(row: categorias.count-1, section: 0)
                //Desordenar y añadir

                collectionView.insertItems(at: [newIndexPath])
                savecat()
                collectionView.reloadData()
            }
        }else{//Si se ha entrado a ver las series de esa categoria
            if let destino = sender.source as? CategoriaListaViewController{
                //AQUI llegan solo series y hay que unirlo
//                let aux = serie
                serie.removeAll()//Se borran y se sustituyen por las nuevas que se hayan modificado
                serie = destino.todasSeries!
//                for i in aux{
//                    if(i.categoria != destino.categoria?.nombre){
//                        serie.append(i)
//                    }
//                }
//
//                for i in destino.series!{
//                    serie.append(i);
//                }
                
                
                
                save()
                
                
            }
        }
        
        self.origen = 1;//se pone a 1 como que viene de otros segues
    }
    
    //Guardar las categorias
    private func savecat(){
        let guardadoCorrecto = NSKeyedArchiver.archiveRootObject(catCopia, toFile: Categoria.ArchveURL.path)
        
        if guardadoCorrecto {
            os_log("Guardados",log: OSLog.default, type: .debug)
        }else{
            os_log("No guardados",log: OSLog.default, type: .error)
        }
    }
    //cargar las categorias
    private func load() -> [Categoria]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Categoria.ArchveURL.path) as? [Categoria]
    }
    
   
    //Funcion de matener presionado
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {//se consigue el indice de la que se ha presionado
            var cell = self.collectionView.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            
            //Creamos un menu actionsheet para eliminar y editar
            let sheet = UIAlertController(title: categorias[index.row].nombre, message: nil, preferredStyle: .actionSheet)
            let editar = UIAlertAction(title: "Editar", style: .default) { (action) in
                self.indice = index.row
                self.boton(nil)//Al editar usa un segue artificial para acceder
            }
            let borrar = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
            
            
                //Si se pulsa borrar mmuetsra mensaje de confirmacion
                    let alert = UIAlertController(title: "Eliminar elemento", message: "¿Seguro que quieres eliminar este elemento?", preferredStyle: .alert)
                    let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    let aceptar = UIAlertAction(title: "Eliminar", style: .destructive, handler: { (action) in
                        for i in 0...self.catCopia.count-1{
                            if(self.catCopia[i] === self.categorias[index.row]){
                                    self.catCopia.remove(at: i)
                                    break
                                }
                            }
                        
                        for i in 0...self.serie.count-1{
                            if(self.serie[i].categoria == self.categorias[index.row].nombre){
                                self.serie.remove(at: i)
                            }
                        }
                        self.save()
                        self.categorias.remove(at: index.row)
                        self.savecat()
                        self.collectionView.deleteItems(at: [index])
                        self.collectionView.reloadData()
                    })
            
                    alert.addAction(cancelar)
                    alert.addAction(aceptar)
                    self.present(alert,animated: true,completion: nil)
            }
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            sheet.addAction(editar)
            sheet.addAction(borrar)
            sheet.addAction(cancelar)
            
            sheet.view.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            present(sheet, animated: true, completion: nil)
            
        } else {
            print("Could not find index path")
        }
    }
    //Antes de desaparecer manda al tabbar las series modificadas
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as? TabViewController
        tabBar?.series = self.serie
        
    }
    //una vez que ha aparecido si venimos de tabbar cargamos los datos de series del tabbar, sino no se hace nada
    override func viewWillAppear(_ animated: Bool) {
        if(origen == 0){
            let tabBar = tabBarController as? TabViewController
            self.serie = (tabBar?.series)!
            
        }else{
            origen = 0;
           
        }
    }
    
    //Al cambiar de segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addItem"://Si es añadir mandamos el segue
            guard let DetailViewController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination")
            }
            guard let controlador = DetailViewController.viewControllers.first as? AddCategoriaViewController else{
                fatalError("Unexpected destination")
            }
            
           controlador.segue = segue.identifier;
            
        case "edit"://Si es editar mandamos la categoria pulsada y el segue
            guard let DetailViewController = segue.destination as? AddCategoriaViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            let selected = categorias[indice]
            DetailViewController.categoria = selected
            DetailViewController.segue = segue.identifier;
            
            nombreAnt = categorias[indice].nombre
            
        case "ver"://Si es ver le pasamos todas las series, y la categoria
            if let indexPath = collectionView.indexPath(for: (sender as? UICollectionViewCell)!){
                
                guard let DetailViewController = segue.destination as? UINavigationController else{
                    fatalError("Unexpected destination")
                }
                guard let controlador = DetailViewController.viewControllers.first as? CategoriaListaViewController else{
                    fatalError("Unexpected destination")
                }
                
                controlador.todasSeries = self.serie
                controlador.series = self.serie
                let selected = categorias[indexPath.row]
                controlador.categoria = selected
                
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    
    }
    //Guardar las series
    private func save(){
        let guardadoCorrecto = NSKeyedArchiver.archiveRootObject(serie, toFile: Serie.ArchveURL.path)
        
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

