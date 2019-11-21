//
//  ConsumablesCell.swift
//  InventoryApp
//
//  Created by Meghan on 11/20/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit

class ConsumablesCell: UITableViewCell {

    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var sku: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
