//
//  ViewControllerCart.swift
//  Market Place
//
//  Created by Jose Soarez on 4/28/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewControllerCart: UIViewController {
    
    var modelController = ModelManager.sharedModelManager
    var cart = ModelManager.initCart()

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalPriceLabel.text = "$\(cart.getTotal())"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backToBuy(_ sender: Any) {
        print("its work")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkOut(_ sender: Any) {
        let alert = UIAlertController(title: "Checkout", message: "Your purchase has been successful", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        dismiss(animated: true, completion: nil)
    }
}
extension ViewControllerCart : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cart.cantOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let products = self.cart.cart.filter { (arg0) -> Bool in
            let (_, value) = arg0
            return value != 0
        }
        let product = Array(products.keys)[indexPath.row]
        
        if (self.cart.cart[product] != 0){
            cell.productImageView.image = product.getProductImage()
            cell.productPriceLebel.text = "$\(product.getProductPrice())"
            cell.productNameLabel.text = product.getProductName()
            cell.productUnitLabel.text = "\(self.cart.cart[product] ?? 0) unit"
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}
