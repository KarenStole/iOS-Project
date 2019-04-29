//
//  TableViewCell.swift
//  Market Place
//
//  Created by Jose Soarez on 4/23/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var productPictureImageView: UIImageView!
    @IBOutlet weak var productNameLaber: UILabel!
    @IBOutlet weak var productPriceLaber: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    
    var showAddButton = false
    var showPlusMinButton = true
    var numberOfProducts = 1
    var tableView = UITableView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productPictureImageView.layer.cornerRadius = productPictureImageView.frame.width / 2.0
        productPictureImageView.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.layer.borderWidth = 1
        numberOfProductsLabel.text = "\(numberOfProducts)"
        self.addButton.isHidden = self.showAddButton
        self.plusButton.isHidden = self.showPlusMinButton
        self.minusButton.isHidden = self.showPlusMinButton
        self.numberOfProductsLabel.isHidden = self.showPlusMinButton
        
    }
}
