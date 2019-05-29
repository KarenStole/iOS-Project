//
//  TableViewCellRecord.swift
//  Market Place
//
//  Created by Jose Soarez on 5/19/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

protocol DetailTableViewCellDelegate {
    func goToDetail(cell: TableViewCellRecord) -> Void}

class TableViewCellRecord: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var cartRecord = Cart()
    var delegate : DetailTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        detailButton.layer.cornerRadius = 10
        detailButton.clipsToBounds = true
        detailButton.layer.borderWidth = 2
        detailButton.layer.borderColor = UIColor.purple.cgColor
    }
    
    @IBAction func goToDetail(_ sender: Any) {
        delegate?.goToDetail(cell: self)
    }
}
