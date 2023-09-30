//
//  ComentarioViewController.swift
//  iSee
//
//  Created by Jose Antonio on 22/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit
import os.log

class ComentarioViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var texto: UITextView!//Campo de texto
    @IBOutlet weak var save: UIBarButtonItem!//Boton de guardar
    @IBOutlet weak var cancel: UIBarButtonItem!//Boton de cancelar
    
    @IBOutlet weak var titulo: UITextField! //Titulo
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        texto.delegate = self;
        titulo.delegate = self;
        // Do any additional setup after loading the view.
        updateSaveButtonState()
        
        //tapgesture para dejar de escribir en el campo
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        //Se cambian los colores del campo texto
        let myColor = UIColor.init(red: 78/255, green: 96/255, blue: 104/255, alpha: 1)
        titulo.layer.borderColor = myColor.cgColor
        titulo.layer.borderWidth = 2
        
        titulo.attributedPlaceholder = NSAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 129/255, green: 144/255, blue: 165/255, alpha: 255/255)])
        
        texto.becomeFirstResponder()
    }
    
    //Se desactiva cursor
    @objc func handleTap() {
        texto.resignFirstResponder() // dismiss keyoard
    }
    //al pulsar en guardar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        guard let button = sender as? UIBarButtonItem, button === save else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
    }
    
    
    //Acualiza boton al terminar de escribir
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    //Al comenzar a escribir se desactiva el boton guardar
    func textViewDidBeginEditing(_ textView: UITextView) {
        save.isEnabled = false
    }
    //Actualizar botones
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = texto.text ?? ""
        let tit = titulo.text ?? ""
        save.isEnabled = !text.isEmpty && !tit.isEmpty
    }
    //Boton cancelar
    @IBAction func botonCancelar(_ sender: UIBarButtonItem) {
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
