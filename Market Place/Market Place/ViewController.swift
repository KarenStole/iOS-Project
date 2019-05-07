//
//  ViewController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartButton: UIButton!
    
    let modelController = ModelManager.sharedModelManager
    var categories : [String] = []
    var products : [Product] = []
    var promotions : [Promotions] = []
    var searchProduct = [String]()
    var searchActive : Bool = false
    var buttonAddStatusFormCells: [[Product : Bool]] = []
    
    /* Set the init values from the params:
     categories : List the caregories in the Products.plist
     products : List the products in the Products.plsit
     promotions : List of all promotion in the Promotions.plist
     pageControl : Set the number of pages
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = ModelManager.getProductCategoryFromFile()
        products = ModelManager.getProductsFromFile()
        promotions = ModelManager.getPromotions()
        pageControl.numberOfPages = promotions.count
        initCellButtonStatus()
    }
    
    /* Set the the status button from the cells (hidden or not hidden)
     Allows to click in the cartButton only if the cart isn't empty
     Reload the tableView for new data
     */
    override func viewWillAppear(_ animated: Bool) {
        cartButton.isUserInteractionEnabled = modelController.emptyCart
        if(!modelController.emptyCart){
            initCellButtonStatus()
        }
        tableView.reloadData()
    }
    
    /* Move from the ViewControllerCart if the cart have elements*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ViewControllerCart = segue.destination as! ViewControllerCart
        destVC.modelController = modelController
        
    }
    
    /* Function that init buttonAddStatusFormCells (array (representing the section) of dictionary(representing the element per section [Product:Bool])) */
    func initCellButtonStatus(){
        buttonAddStatusFormCells.removeAll()
        for category in 0..<categories.count{
            var productInCat = [Product:Bool]()
            for product in ModelManager.getProductForCategory(caregoryIndex: category){
                productInCat[product] = false
                }
            buttonAddStatusFormCells.append(productInCat)
            productInCat.removeAll()
        }
    }
    
    /* Show or hide the Add button from a selected cell*/
    @IBAction func showHideButton(_ sender: Any) {
        // getting the button indexPth from the tableView
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            //Getting the product from the selected cell
            let productOfIndexDefined = (tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let productOfIndexDefined = productOfIndexDefined {
                if let quantityOfProduct = modelController.cart.cart[productOfIndexDefined]{
                    //Adding one of the selected product in the cart
                    modelController.addProductIntoTheCart(product: productOfIndexDefined, quantity: quantityOfProduct+1, cart: modelController.cart)
                    buttonAddStatusFormCells[indexPath.section][productOfIndexDefined] = true
                }
            }
            //Refresh the cell to get the actual product's quantity
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        // change the cartButton status (allowed to click)
        cartButton.isUserInteractionEnabled = modelController.isCartEmpty(cart: modelController.cart)
    }
    
    /* Add product into the cart (+ button) */
    @IBAction func addProductToCart(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            let productOfIndexDefined = (tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let productOfIndexDefined = productOfIndexDefined{
                if let quantityOfProduct = modelController.cart.cart[productOfIndexDefined]{
                    modelController.addProductIntoTheCart(product: productOfIndexDefined, quantity: quantityOfProduct+1, cart: modelController.cart)
                    buttonAddStatusFormCells[indexPath.section][productOfIndexDefined] = true
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    /* If product quantity is > 0, just change the quantity in the cart
        else, also change the quantity in the cart and hide "+", "quantity", "-" buttons
     */
    @IBAction func showHideMinPlusButton(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            let productOfIndexDefined = (tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let productOfIndexDefined = productOfIndexDefined{
                if let quantityOfProduct = modelController.cart.cart[productOfIndexDefined]{
                    if(modelController.cart.cart[productOfIndexDefined] != 0){
                        modelController.addProductIntoTheCart(product: productOfIndexDefined, quantity: quantityOfProduct-1, cart: modelController.cart)
                    }
                    if(modelController.cart.cart[productOfIndexDefined] == 0){
                        buttonAddStatusFormCells[indexPath.section][productOfIndexDefined] = false
                    }
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        cartButton.isUserInteractionEnabled = modelController.isCartEmpty(cart: modelController.cart)
    }
    
    /* Swich to the checkOut viewController*/
    @IBAction func goToCheckout(_ sender: Any) {
        performSegue(withIdentifier: "checkOutView", sender: self)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return categories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive){
            var count = 0
            let products = ModelManager.getProductForCategory(caregoryIndex: section)
            let productsNames = ModelManager.getProductsName(products: products)
            for index in 0..<searchProduct.count{
                if(productsNames.contains(searchProduct[index])){
                        count+=1
                        
                    }
                }
            return count
            }
        
        else{
            return ModelManager.getProductForCategory(caregoryIndex: section).count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableView", for: indexPath) as! TableViewCell
        cell.tableView = tableView
        let product = ModelManager.getProductForCategory(caregoryIndex: indexPath.section)
        //if im searching
        if(searchActive){
            for prod in  product{
                for prodNameSearched in searchProduct{
                    //iterate in all products in the market and also the searched names, if each names are equals, show only these in the tableView
                if(prod.getProductName() == prodNameSearched){
                    if let status = buttonAddStatusFormCells[indexPath.section][prod]{
                        if let quantity = modelController.cart.cart[prod]{
                            print("entro")
                            cell.product = prod
                            cell.productNameLaber.text = prod.getProductName()
                            cell.productPriceLaber.text = "$\(prod.getProductPrice())"
                            cell.productPictureImageView.image = prod.getProductImage()
                            cell.showAddButton = status
                            cell.showPlusMinButton = !status
                            cell.numberOfProducts = quantity
                            }
                        }
                    }
                }
            }
        }
        // if im not searching show all the products
        else{
            if let status = buttonAddStatusFormCells[indexPath.section][product[indexPath.row]]{
                if let numOfProduct = modelController.cart.cart[product[indexPath.row]]{
                    cell.product = product[indexPath.row]
                    cell.productNameLaber.text = product[indexPath.row].getProductName()
                    cell.productPriceLaber.text = "$\(product[indexPath.row].getProductPrice())"
                    cell.productPictureImageView.image = product[indexPath.row].getProductImage()
                    cell.showAddButton = status
                    cell.showPlusMinButton = !status
                    cell.numberOfProducts = numOfProduct
                    
                }
            }
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }

    
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath) as! CollectionViewCellPromotion
        
        cell.bannerImaeView.image = promotions[indexPath.row].image
        cell.textMinLabel.text = promotions[indexPath.row].label1
        cell.textMaxLabel.text = promotions[indexPath.row].label2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-10, height: collectionView.frame.size.height-10)
    }
    
}

extension ViewController : UISearchBarDelegate{
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchProduct = ModelManager.getProductsName(products: products).filter({ $0.prefix(searchText.count) == searchText })
    if(searchProduct.count != products.count){
        searchActive = true}
    else{
        searchActive = false}
    tableView.reloadData()
    }
    
}

