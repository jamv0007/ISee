//
//  TemporadaTableViewCell.swift
//  iSee
//
//  Created by Jose Antonio on 13/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class TemporadaTableViewCell: UITableViewCell {

    @IBOutlet weak var nTemporada: UILabel!
    @IBOutlet weak var viendo: UISwitch!
    @IBOutlet weak var capitulos: UIButton!
    @IBOutlet weak var recordar: UIButton!
    
    var nCapitulos = 0
    var recordatorio = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Color celda seleccionada
        self.selectionStyle = UITableViewCell.SelectionStyle.gray
        let Color = UIView()
        Color.backgroundColor = UIColor(red: 78/255, green: 96/255, blue: 104/255, alpha: 1)
        
        self.selectedBackgroundView = Color;
        
        //Estilo botones
        capitulos.layer.cornerRadius = 5
        capitulos.layer.borderWidth = 1
        capitulos.layer.borderColor = UIColor.gray.cgColor
        recordar.layer.cornerRadius = 5
        recordar.layer.borderWidth = 1
        recordar.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
