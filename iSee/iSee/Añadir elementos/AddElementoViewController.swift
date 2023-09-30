//
//  AddElementoViewController.swift
//  iSee
//
//  Created by Jose Antonio on 13/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log
import UserNotifications

class AddElementoViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var saveButton: UIBarButtonItem!//Boton guardar
    @IBOutlet weak var img: UIImageView!//Imagen
    @IBOutlet weak var puntuacion: RatingControl!//Puntuacion
    @IBOutlet weak var nombreElemento: UITextField!//Campo texto
    @IBOutlet weak var add: UIButton!//Boton añadir
  
    
    var serie: Serie? //Serie
    var temp = [Temporada](); //Temporadas
    var categoria: String = "" //Categoria
    var segue: String? //Segue por el que ha venido
    var ntemp: Int? //Numero de temporadas
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cargamos la serie si estamos modificando
        if let categoria = serie{
            navigationItem.title = serie?.nombre
            nombreElemento.text = serie?.nombre
            img.image = serie?.foto
            puntuacion.rating = (serie?.rating)!
        }
        

        ntemp = temp.count;
        nombreElemento.delegate = self
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
        
        //Color borde texto
        let myColor = UIColor.init(red: 78/255, green: 96/255, blue: 104/255, alpha: 1)
        nombreElemento.layer.borderColor = myColor.cgColor
        nombreElemento.layer.borderWidth = 2
        
        //Cambiamos el color del status bar
        nombreElemento.attributedPlaceholder = NSAttributedString(string: "Nombre del elemento", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 129/255, green: 144/255, blue: 165/255, alpha: 255/255)])
        
        //Tap gesture para delegar del cuadro de texto
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    //delegar del cuadro de texto
    @objc func handleTap() {
        nombreElemento.resignFirstResponder() // dismiss keyoard
    }
    
    //Funciones para bloqueal el boton save si el campo de texto no esta lleno
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        
        
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nombreElemento.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    
    //Delegar el campo de texto
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nombreElemento.resignFirstResponder()
        return true
    }
    //Boton de cancelar
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        if let cont = self.segue{
            if(cont == "addElemento"){
                dismiss(animated: true, completion: nil)
            }else if(cont == "modificarElemento"){
                if let owningNavigationController = navigationController{
                    owningNavigationController.popViewController(animated: true)
                }else{
                    fatalError("El viewController no esta dentro de la navegacion")
                }
            }else{
                fatalError("El viewController no esta dentro de la navegacion")
            }
        }
    }
    //Seleccion de imagenes
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Este código garantiza que si el usuario toca la vista de la imagen mientras escribe en el campo de texto, el teclado se cierra correctamente.
        nombreElemento.resignFirstResponder();
        //Control de selector de imagenes
        let imagePickerController = UIImagePickerController();
        //establece la fuente del controlador del selector de imágenes, o el lugar donde obtiene sus imágenes. La .photoLibrary utiliza la galeria de la camara
        imagePickerController.sourceType = .photoLibrary;
        //imagePickerController.sourceType es una enumeracion
        //Para que el detectar que se toca la foto
        imagePickerController.delegate = self;
        //recurre ViewController.Se ejecuta en un self objeto. El método solicita al ViewController presentar el controlador de vista definido por imagePickerController.true anima la presentación del controlador del selector de imágenes. El completion se refiere a un controlador de finalización , un fragmento de código que se ejecuta después de que se completa este método. Como no necesita hacer nada más,  nil .
        present(imagePickerController, animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Anima el controlador del selector de imagenes
        dismiss(animated: true, completion: nil);
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        img.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    //Vuelta de añadir temporadas
    @IBAction func unwindTemporada(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TemporadaTableViewController, let cat: [Temporada] = sourceViewController.temp {
            
            self.temp = cat;
            
            
        }
    }
    
    //Prepare para añadir temporadas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == "addTemporada"){//Si se esta añadiendo o modificando
            
            guard let DetailViewController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination")
            }
            guard let controlador = DetailViewController.viewControllers.first as? TemporadaTableViewController else{
                fatalError("Unexpected destination")
            }
            
            controlador.temporada = temp
            controlador.n = temp.count
            
        }else{ //Si estamos volviendo a la lista de series 
        
            // Configure the destination view controller only when the save button is pressed.
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            
            
        
            let nombre = nombreElemento.text ?? ""
            let fotoCat = img.image

            // Set the meal to be passed to MealTableViewController after the unwind segue.
            serie = Serie(nombre: nombre, foto: fotoCat, rating: puntuacion.rating, categoria: categoria, temporadas: temp, viendo: false, terminada: false)
            
            
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
