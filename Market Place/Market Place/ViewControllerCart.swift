//
//  ViewControllerCart.swift
//  Market Place
//
//  Created by Jose Soarez on 4/28/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Kingfisher


class ViewControllerCart: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkOutButon: UIButton!
    
    var modelController = ModelManager.sharedModelManager
    var modelControllerRecord = RecordModelManager.sharedModelManager
    var typeValue = 1
    var isRecordViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "$\(modelController.cart.getTotal())"
        checkOutButon.layer.cornerRadius = 20
    }
    
    //######### One section in pickerView ################
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //######## Ten elements in the pickerView ############
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    //######## Element 1 to 10 in the pickerViewr #######
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    //######## Getting the selected picker value #######
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeValue = row+1
    }
    
    //######## Checkout's button action, empty the cart ando go back to the previous view controller ###########################
    @IBAction func checkOut(_ sender: Any) {
        
        ModelManager.postCheckOut(token: self.modelController.token, cart: self.modelController.cart, completionHandler: { response, error in
            if let response = response{
                let alert = UIAlertController(title: "Checkout", message: response, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    self.modelController.cart = Cart.initCart()
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
            }
            
        })
    }
}
extension ViewControllerCart : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //######## Set the numbers of items in the CollectionView ############################################
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isRecordViewController){
            return modelControllerRecord.cart.cantOfProducts()
        }
        else{
            return modelController.cart.cantOfProducts()
        }
        
    }
    
    //####### Set the collectionViews's cell settings (image and labels) for only thoes prodoucts in the cart which quantity is > 0 ####
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        // Getting the items form the cart that value is > 0
        var cart : Cart
        if(isRecordViewController){
            cart = modelControllerRecord.cart
        }else{
            cart = modelController.cart
        }
        let products = cart.cart.filter { (arg0) -> Bool in
            let (item) = arg0
            return item.quantity != 0
        }
        let cartItem = products[indexPath.row]
        
        if ( cartItem.quantity != 0){
            cell.product = cartItem.product
            if let image = cartItem.product!.image{
                cell.productImageView.kf.setImage(with: URL(string: image))
            }
            else {
                cell.productImageView.kf.setImage(with: URL(string: "https://static.thenounproject.com/png/340719-200.png"))
                
            }
            cell.productPriceLebel.text = "$\(cartItem.product!.price ?? 0)"
            cell.productNameLabel.text = cartItem.product!.name
            cell.productUnitLabel.text = "\(cartItem.quantity ?? 0) unit"
            
        }
        
        return cell
    }
    
    //################# Setting only two colums in the CollectionView #########################################################
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 10
        let collectionCellSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionCellSize/2, height: collectionCellSize*0.70)
        
    }
    
    //##Show an alert with a picker when a item from collectionView is selected and also setting the product's quantity when the alert is closed ##
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!isRecordViewController){
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 300)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            pickerView.delegate = self
            pickerView.dataSource = self
            vc.view.addSubview(pickerView)
            let cellCollectionView = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            if let product = cellCollectionView.product{
                let quantity = modelController.cart.cart.filter { (arg0) -> Bool in
                    let (cartItem) = arg0
                    return (cartItem.product == product)
                }
                if let first = quantity.first{
                pickerView.selectRow((first.quantity)! - 1, inComponent: 0, animated: true)
                typeValue = (first.quantity)!
            }
            }
            let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
                UIAlertAction in
                    let cellCollectionView = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                    if let product = cellCollectionView.product{
                        let quantity = self.modelController.cart.cart.filter { (arg0) -> Bool in
                            let (cartItem) = arg0
                            return (cartItem.product == product)
                            }
                        if let first = quantity.first{
                            first.quantity = self.typeValue
                        }
                        
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                self.totalPriceLabel.text = "$\(self.modelController.cart.getTotal())"
            }
            let editUnitsAlert = UIAlertController(title: "Change the units", message: "", preferredStyle: UIAlertController.Style.alert)
            editUnitsAlert.setValue(vc, forKey: "contentViewController")
            editUnitsAlert.addAction(doneAction)
            editUnitsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(editUnitsAlert, animated: true)
        }
    }
}
