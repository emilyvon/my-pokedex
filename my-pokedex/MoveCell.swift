//
//  MoveCell.swift
//  my-pokedex
//
//  Created by Mengying Feng on 16/02/2016.
//  Copyright © 2016 Mengying Feng. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(nameStr: String, typeStr: String) {
        if nameStr == "tutor"{
            nameLbl.backgroundColor = UIColor(red: 118/255, green: 250/255, blue: 175/255, alpha: 1.0)
        } else if nameStr == "machine" {
            nameLbl.backgroundColor = UIColor(red: 145/255, green: 145/255, blue: 255/255, alpha: 1.0)
        } else if nameStr == "level up" {
            nameLbl.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 137/255, alpha: 1.0)
        } else {
            nameLbl.backgroundColor = UIColor(red: 136/255, green: 243/255, blue: 208/255, alpha: 1.0)
        }
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.layer.cornerRadius = 8.0
        nameLbl.clipsToBounds = true
        nameLbl.text = nameStr
        typeLbl.text = typeStr
    }
}
