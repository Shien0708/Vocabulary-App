//
//  CollectionTableViewCell.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/29.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var chLabel: UILabel!
    @IBOutlet weak var enLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
