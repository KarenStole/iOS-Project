//
//  ViewController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let modelController = ModelManager.sharedModelManager
    var categories : [String] = []
    var products : [Product] = []
    var promotions : [Promotions] = []
    var searchProduct = [String]()
    var searchActive : Bool = false
    var buttonAddStatusFormCells: [[Product : Bool]] = []
    

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartButton: UIButton!
    
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
        pageControl.numberOfPages = self.promotions.count
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
        destVC.modelController = self.modelController
        
    }
    
    /* Function that init buttonAddStatusFormCells (array (representing the section) of dictionary(representing the element per section [Product:Bool])) */
    func initCellButtonStatus(){
        self.buttonAddStatusFormCells.removeAll()
        for category in 0..<categories.count{
            var productInCat = [Product:Bool]()
            for product in ModelManager.getProductForCategory(caregoryIndex: category){
                productInCat[product] = false
                }
            self.buttonAddStatusFormCells.append(productInCat)
            productInCat.removeAll()
        }
    }
    
    /* Show or hide the Add button from a selected cell*/
    @IBAction func showHideButton(_ sender: Any) {
        // getting the button indexPth from the tableView
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            //Getting the product from the selected cell
            let productOfIndexDefined = (self.tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let quantityOfProduct = self.modelController.cart.cart[productOfIndexDefined!]{
                //Adding one of the selected product in the cart
                self.modelController.addProductIntoTheCart(product: productOfIndexDefined!, quantity: quantityOfProduct+1, cart: self.modelController.cart)
                buttonAddStatusFormCells[indexPath.section][productOfIndexDefined!] = true
            }
            //Refresh the cell to get the actual product's quantity
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        // change the cartButton status (allowed to click)
        self.cartButton.isUserInteractionEnabled = modelController.isCartEmpty(cart: self.modelController.cart)
    }
    
    /* Add product into the cart (+ button) */
    @IBAction func addProductToCart(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            let productOfIndexDefined = (self.tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let quantityOfProduct = self.modelController.cart.cart[productOfIndexDefined!]{
                self.modelController.addProductIntoTheCart(product: productOfIndexDefined!, quantity: quantityOfProduct+1, cart: self.modelController.cart)
                buttonAddStatusFormCells[indexPath.section][productOfIndexDefined!] = true
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
 //       self.cartButton.isUserInteractionEnabled = modelController.isCartEmpty(cart: self.modelController.cart)
    }
    
    /* If product quantity is > 0, just change the quantity in the cart
        else, also change the quantity in the cart and hide "+", "quantity", "-" buttons
     */
    @IBAction func showHideMinPlusButton(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        if let indexPath = indexPath {
            let productOfIndexDefined = (self.tableView.cellForRow(at: indexPath) as! TableViewCell).product
            if let quantityOfProduct = self.modelController.cart.cart[productOfIndexDefined!]{
                if(self.modelController.cart.cart[productOfIndexDefined!] != 0){
                    self.modelController.addProductIntoTheCart(product: productOfIndexDefined!, quantity: quantityOfProduct-1, cart: self.modelController.cart)
                }
                if(self.modelController.cart.cart[productOfIndexDefined!] == 0){
                    buttonAddStatusFormCells[indexPath.section][productOfIndexDefined!] = false
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
        }
        self.cartButton.isUserInteractionEnabled = modelController.isCartEmpty(cart: self.modelController.cart)
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
        
        if(self.searchActive){
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
        cell.tableView = self.tableView
        let product = ModelManager.getProductForCategory(caregoryIndex: indexPath.section)
        //if im searching
        if(searchActive){
            for prod in  product{
                for prodNameSearched in self.searchProduct{
                    //iterate in all products in the market and also the searched names, if each names are equals, show only these in the tableView
                if(prod.getProductName() == prodNameSearched){
                    print("entro")
                    cell.product = prod
                    cell.productNameLaber.text = prod.getProductName()
                    cell.productPriceLaber.text = "$\(prod.getProductPrice())"
                    cell.productPictureImageView.image = prod.getProductImage()
                    cell.showAddButton = buttonAddStatusFormCells[indexPath.section][prod]!
                    cell.showPlusMinButton = !buttonAddStatusFormCells[indexPath.section][prod]!
                    cell.numberOfProducts = self.modelController.cart.cart[prod]!
                }
            }
            }
        }
        // if im not searching show all the products
        else{
            cell.product = product[indexPath.row]
            cell.productNameLaber.text = product[indexPath.row].getProductName()
            cell.productPriceLaber.text = "$\(product[indexPath.row].getProductPrice())"
            cell.productPictureImageView.image = product[indexPath.row].getProductImage()
            cell.showAddButton = buttonAddStatusFormCells[indexPath.section][product[indexPath.row]]!
            cell.showPlusMinButton = !buttonAddStatusFormCells[indexPath.section][product[indexPath.row]]!
            cell.numberOfProducts = self.modelController.cart.cart[product[indexPath.row]]!
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }

    
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.promotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath) as! CollectionViewCellPromotion
        
        cell.bannerImaeView.image = self.promotions[indexPath.row].image
        cell.textMinLabel.text = self.promotions[indexPath.row].label1
        cell.textMaxLabel.text = self.promotions[indexPath.row].label2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    
}

extension ViewController : UISearchBarDelegate{
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchProduct = ModelManager.getProductsName(products: self.products).filter({ $0.prefix(searchText.count) == searchText })
    if(searchProduct.count != self.products.count){
        searchActive = true}
    else{
        searchActive = false}
    self.tableView.reloadData()
    }
    
}

