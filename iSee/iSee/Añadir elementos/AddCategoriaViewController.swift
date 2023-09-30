//
//  AddCategoriaViewController.swift
//  iSee
//
//  Created by Jose Antonio on 9/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class AddCategoriaViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem! //Boton cancel
    
    @IBOutlet weak var saveButton: UIBarButtonItem! //Boton save
    @IBOutlet weak var foto: UIImageView! //Imagen
    @IBOutlet weak var nombreCategoria: UITextField! //Campo texto
    
    var categoria: Categoria? //categoria a la hora de modificar o añadir
    var segue: String? //Segue por el que ha venido
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreCategoria.delegate = self
        
        if let categoria = categoria{
            navigationItem.title = categoria.nombre
            nombreCategoria.text = categoria.nombre
            foto.image = categoria.foto
            
        }
        
        // Do any additional setup after loading the view.
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Color campo texto
        let myColor = UIColor.init(red: 78/255, green: 96/255, blue: 104/255, alpha: 1)
        nombreCategoria.layer.borderColor = myColor.cgColor
        nombreCategoria.layer.borderWidth = 2
        
        nombreCategoria.attributedPlaceholder = NSAttributedString(string: "Nombre de la categoria", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 129/255, green: 144/255, blue: 165/255, alpha: 255/255)])
        
        
        updateSaveButtonState()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func handleTap() {
        nombreCategoria.resignFirstResponder() // dismiss keyoard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        //Guardar
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nombre = nombreCategoria.text ?? ""
        let fotoCat = foto.image
        
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        categoria = Categoria(nombre: nombre, foto: fotoCat)
    }
    
    
//Boton cancelar
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        if let cont = self.segue{
            if(cont == "addItem"){
                dismiss(animated: true, completion: nil)
            }else if(cont == "edit"){
                if let owningNavigationController = navigationController{
                    owningNavigationController.popViewController(animated: true)
                }else{
                    fatalError("El viewController no esta dentro de la navegacion")
                }
            }else{
                fatalError("El viewController no esta dentro de la navegacion")
            }
        }
        
        
//        let isPresentingInAddLugarMode = presentingViewController is UINavigationController
//
//        if isPresentingInAddLugarMode {
//
//            dismiss(animated: true, completion: nil)
//
//        }else if let owningNavigationController = navigationController{
//
//            owningNavigationController.popViewController(animated: true)
//
//        }else {
//
//            fatalError("El viewController no esta dentro de la navegacion")
//        }
    }
    //Boton guardar no se habilite hasta que haya texto
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        
        
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nombreCategoria.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nombreCategoria.resignFirstResponder()
        return true
    }
    
    
    //Seleccion de imagenes
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Este código garantiza que si el usuario toca la vista de la imagen mientras escribe en el campo de texto, el teclado se cierra correctamente.
        nombreCategoria.resignFirstResponder();
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
        foto.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
