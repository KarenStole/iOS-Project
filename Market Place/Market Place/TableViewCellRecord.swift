//
//  TableViewCellRecord.swift
//  Market Place
//
//  Created by Jose Soarez on 5/19/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class TableViewCellRecord: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var cartRecord = Cart()
    
    @IBOutlet weak var detailButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        detailButton.layer.cornerRadius = 10
        detailButton.clipsToBounds = true
        detailButton.layer.borderWidth = 2
        detailButton.layer.borderColor = UIColor.purple.cgColor
    }
}
