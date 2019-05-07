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
    
    var product: Product?
    var showAddButton = false
    var showPlusMinButton = true
    var numberOfProducts = 1
    var tableView = UITableView()
    
    //Setting the style of the items in the cell
    override func layoutSubviews() {
        super.layoutSubviews()
        productPictureImageView.layer.cornerRadius = productPictureImageView.frame.width / 2.0
        productPictureImageView.layer.masksToBounds = true
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.purple.cgColor
        numberOfProductsLabel.text = "\(numberOfProducts)"
        addButton.isHidden = self.showAddButton
        plusButton.isHidden = self.showPlusMinButton
        minusButton.isHidden = self.showPlusMinButton
        numberOfProductsLabel.isHidden = self.showPlusMinButton
        
    }
}
