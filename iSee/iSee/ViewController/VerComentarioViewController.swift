//
//  VerComentarioViewController.swift
//  iSee
//
//  Created by Jose Antonio on 22/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class VerComentarioViewController: UIViewController {
    
    var  usu: String?//titulo
    var text : String?//texto


    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var titulo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        titulo.text = usu;
        texto.text = text;
        // Do any additional setup after loading the view.
        
        let myColor = UIColor.init(red: 129/255, green: 144/255, blue: 165/255, alpha: 255/255)
        titulo.layer.borderColor = myColor.cgColor
        titulo.layer.borderWidth = 0
        
        titulo.attributedPlaceholder = NSAttributedString(string: "Titulo", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 129/255, green: 144/255, blue: 165/255, alpha: 255/255)])
    }
    
    @IBAction func atras(_ sender: UIBarButtonItem) {
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
