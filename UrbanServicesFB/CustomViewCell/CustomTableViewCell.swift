//
//  CustomTableViewCell.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 31/03/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var CellName: UILabel!
    @IBOutlet weak var CellAge: UILabel!
    @IBOutlet weak var CellGender: UILabel!
    @IBOutlet weak var CellContact: UILabel!
    @IBOutlet weak var CellImageView: UIImageView!
    @IBOutlet weak var CellJobCat: UITextField!
    @IBOutlet weak var CellStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
