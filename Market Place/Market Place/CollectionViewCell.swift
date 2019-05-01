//
//  CollectionViewCell.swift
//  Market Place
//
//  Created by Jose Soarez on 4/28/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLebel: UILabel!
    @IBOutlet weak var productUnitLabel: UILabel!
    var product: Product?
    
}
