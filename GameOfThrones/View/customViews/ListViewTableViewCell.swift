//
//  ListViewTableViewCell.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var itemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dotView.layer.cornerRadius = dotView.bounds.height / 2
        mainContentView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
