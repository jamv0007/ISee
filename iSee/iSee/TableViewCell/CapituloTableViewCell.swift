//
//  CapituloTableViewCell.swift
//  iSee
//
//  Created by Jose Antonio on 20/4/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class CapituloTableViewCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var visto: UISwitch!
    
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
