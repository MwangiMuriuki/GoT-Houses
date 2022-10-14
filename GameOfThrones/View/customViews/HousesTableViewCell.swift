//
//  HousesTableViewCell.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 12/10/2022.
//

import UIKit

class HousesTableViewCell: UITableViewCell {

    @IBOutlet weak var houseNumberBG: UIView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseRegionLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        houseNumberBG.layer.cornerRadius = houseNumberBG.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configureCells(with model: HousesDataClass){

        self.houseNameLabel.text = model.name
        self.houseRegionLabel.text = model.region

    }
    
}
