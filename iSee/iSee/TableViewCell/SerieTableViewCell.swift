//
//  SerieTableViewCell.swift
//  iSee
//
//  Created by Jose Antonio on 25/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import UIKit

class SerieTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ep: UILabel!
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var rating: RatingControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
