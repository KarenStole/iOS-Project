//
//  ViewControllerCart.swift
//  Market Place
//
//  Created by Jose Soarez on 4/28/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

protocol InformationBackProtocol {
    func setResultOfBusinessLogic(valueSent: Cart)
}

class ViewControllerCart: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var modelController = ModelManager.sharedModelManager
    var cart = Cart.initCart()
    var delegate : InformationBackProtocol?
    var typeValue = Int()

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalPriceLabel.text = "$\(cart.getTotal())"

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.typeValue = row+1
    }
    

    @IBAction func backToBuy(_ sender: Any) {
        self.modelController.cart = self.cart
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkOut(_ sender: Any) {
        let alert = UIAlertController(title: "Checkout", message: "Your purchase has been successful", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
            self.modelController.cart = Cart.initCart()
            self.modelController.emptyCart = true
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
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
            cell.product = product
            cell.productImageView.image = product.getProductImage()
            cell.productPriceLebel.text = "$\(product.getProductPrice())"
            cell.productNameLabel.text = product.getProductName()
            cell.productUnitLabel.text = "\(self.cart.cart[product] ?? 0) unit"
     /*       let UITapRecognizer = UITapGestureRecognizer()
            UITapRecognizer.addTarget(self, action: #selector(tappedImage))
            cell.productImageView.addGestureRecognizer(UITapRecognizer)
            cell.productImageView.isUserInteractionEnabled = true*/
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
            UIAlertAction in
                let cellCollectionView = self.collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                if let product = cellCollectionView.product{
                    self.cart.cart[product] = self.typeValue
                    self.collectionView.reloadItems(at: [indexPath])
                }
            self.totalPriceLabel.text = "$\(self.cart.getTotal())"
        }
        let editUnitsAlert = UIAlertController(title: "Change the units", message: "", preferredStyle: UIAlertController.Style.alert)
        editUnitsAlert.setValue(vc, forKey: "contentViewController")
        editUnitsAlert.addAction(doneAction)
        editUnitsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editUnitsAlert, animated: true)
    }
}
