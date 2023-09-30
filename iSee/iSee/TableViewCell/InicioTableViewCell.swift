//
//  InicioTableViewCell.swift
//  iSee
//
//  Created by Jose Antonio on 24/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class InicioTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var actual: UILabel!
    @IBOutlet weak var puntuacion: UILabel!
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var categoria: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Color celda seleccionada
        self.selectionStyle = UITableViewCell.SelectionStyle.gray
        let Color = UIView()
        Color.backgroundColor = UIColor(red: 78/255, green: 96/255, blue: 104/255, alpha: 1)
        
        self.selectedBackgroundView = Color;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
