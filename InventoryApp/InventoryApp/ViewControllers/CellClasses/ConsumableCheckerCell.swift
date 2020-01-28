//
//  ConsumableCheckerCell.swift
//  InventoryApp
//
//  Created by Meghan on 1/28/20.
//  Copyright © 2020 Herberger IT. All rights reserved.
//

import UIKit

class ConsumableCheckerCell: UITableViewCell {

    @IBOutlet weak var adapterType: UILabel!
    @IBOutlet weak var sku: UILabel!
    @IBOutlet weak var expectedCount: UILabel!
    @IBOutlet weak var actualCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
