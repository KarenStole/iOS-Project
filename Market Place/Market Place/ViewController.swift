//
//  ViewController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Kingfisher

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

    }
    
    /* Set the the status button from the cells (hidden or not hidden)
     Allows to click in the cartButton only if the cart isn't empty
     Reload the tableView for new data
     */
    override func viewWillAppear(_ animated: Bool) {
        ModelManager.getProductsFromApi(completionHandler: {result, error in
            if let result = result{
                self.products = result
                self.categories = ModelManager.getProductCategories(listOfProducts: self.products)
                if(self.buttonAddStatusFormCells.isEmpty){
                    self.initCellButtonStatus()
                }
                self.tableView.reloadData()
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading products: \(error.localizedDescription)")
            }
        })
        ModelManager.getPromotionsFromApi(completionHandler: {result, error in
            if let result = result{
                self.promotions = result
                self.pageControl.numberOfPages = self.promotions.count
                self.bannerCollectionView.reloadData()
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading promotions: \(error.localizedDescription)")
            }
        })
        cartButton.isUserInteractionEnabled =
            !modelController.emptyCart
        if(modelController.emptyCart){
            initCellButtonStatus()
            modelController.cart = Cart.initCart()
        }
        tableView.reloadData()
    }
    
    /* Move from the ViewControllerCart if the cart have elements*/
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ViewControllerCart = segue.destination as! ViewControllerCart
        destVC.modelController = modelController
        
    }*/
    
    /* Function that init buttonAddStatusFormCells (array (representing the section) of dictionary(representing the element per section [Product:Bool])) */
    func initCellButtonStatus(){
        buttonAddStatusFormCells.removeAll()
        for category in 0..<categories.count{
            var productInCat = [Product:Bool]()
            for product in ModelManager.getProductForCategory(caregoryIndex: category, listOfProducts: products){
                productInCat[product] = false
                }
            buttonAddStatusFormCells.append(productInCat)
            productInCat.removeAll()
        }
    }

    
    /* Swich to the checkOut viewController*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ViewControllerCart{
            let destinationVC = segue.destination as! ViewControllerCart
            destinationVC.modelController = self.modelController
            destinationVC.isRecordViewController = false
        }else{
            let destinationVC = segue.destination as! ViewControllerRecord
            destinationVC.modelController = self.modelController
        }

    }
    @IBAction func goToCheckout(_ sender: Any) {

        performSegue(withIdentifier: "checkOutView", sender: self)
    }

    @IBAction func goToRecord(_ sender: Any) {
        performSegue(withIdentifier: "recordView", sender: self)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, ProductTableViewCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int{
        if categories.isEmpty{
            return 1
        }
        else{
            return categories.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !categories.isEmpty{
            if(searchActive){
                var count = 0
                let products = ModelManager.getProductForCategory(caregoryIndex: section, listOfProducts: self.products)
                let productsNames = ModelManager.getProductsName(products: products)
                for index in 0..<searchProduct.count{
                    if(productsNames.contains(searchProduct[index])){
                            count+=1
                        
                        }
                    }
                return count
                }
            
            else{
                return ModelManager.getProductForCategory(caregoryIndex: section, listOfProducts: products).count
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if categories.isEmpty{
            return "Loading..."
        }
        else{
            return categories[section].uppercased()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableView", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        let product = ModelManager.getProductForCategory(caregoryIndex: indexPath.section, listOfProducts: products)
        //if im searching
        if(searchActive){
            for prod in  product{
                for prodNameSearched in searchProduct{
                    //iterate in all products in the market and also the searched names, if each names are equals, show only these in the tableView
                if(prod.name == prodNameSearched){
                    if let status = buttonAddStatusFormCells[indexPath.section][prod]{
                        let quantity = Cart.getProductQuantity(product: prod, cart: modelController.cart)
                            print("entro")
                            cell.delegate = self
                            cell.product = prod
                            cell.productNameLaber.text = prod.name
                            let priceFormat = String(format: "%.1f", prod.price!)
                            cell.productPriceLaber.text = "$\(priceFormat)"
                            if let url = prod.image{
                                cell.productPictureImageView.kf.setImage(with: URL(string:url))
                            }
                            else {
                            cell.delegate = self
                            cell.productPictureImageView.kf.setImage(with: URL(string: "https://static.thenounproject.com/png/340719-200.png"))
                            }
                            cell.showAddButton = status
                            cell.showPlusMinButton = !status
                            cell.numberOfProducts = quantity
                            }
                        }
                    
                }
            }
        }
        // if im not searching show all the products
        else{
            if let status = buttonAddStatusFormCells[indexPath.section][product[indexPath.row]]{
                let numOfProduct = Cart.getProductQuantity(product: product[indexPath.row], cart: modelController.cart)
                    cell.delegate = self
                    cell.product = product[indexPath.row]
                    cell.productNameLaber.text = product[indexPath.row].name
                    let priceFormat = String(format: "%.1f", product[indexPath.row].price!)
                    cell.productPriceLaber.text = "$\(priceFormat)"
                    if let url = product[indexPath.row].image{
                        cell.productPictureImageView.kf.setImage(with: URL(string:url))
                    }
                    else {
                        cell.productPictureImageView.kf.setImage(with: URL(string: "https://static.thenounproject.com/png/340719-200.png"))
                    }

                    cell.showAddButton = status
                    cell.showPlusMinButton = !status
                    cell.numberOfProducts = numOfProduct
                
            }
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func addItem(cell: TableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        modelController.addProductIntoTheCart(product: cell.product!, cart: modelController.cart)
        buttonAddStatusFormCells[indexPath!.section][cell.product!] = true
        
            //Refresh the cell to get the actual product's quantity
        tableView.reloadRows(at: [indexPath!], with: .automatic)
        cartButton.isUserInteractionEnabled = !modelController.isCartEmpty(cart: modelController.cart)
    }
    func removeItem(cell: TableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let indexPath = indexPath {
            modelController.removeProductIntoTheCart(product: cell.product!, cart: modelController.cart)
            let quantityOfProduct = Cart.getProductQuantity(product: cell.product!, cart: modelController.cart)
                
                if(quantityOfProduct == 0){
                    buttonAddStatusFormCells[indexPath.section][cell.product!] = false
                }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            cartButton.isUserInteractionEnabled = !modelController.isCartEmpty(cart: modelController.cart)
            
        }
    }

    
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(promotions.isEmpty){
            return 1
        }
        else{
            return promotions.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promotionCell", for: indexPath) as! CollectionViewCellPromotion
        
        if(promotions.isEmpty){
            cell.textMaxLabel.text = "Loading..."
            cell.textMinLabel.text = ""
        }
        else{
            cell.bannerImaeView.kf.setImage(with: URL(string: promotions[indexPath.row].image!))
            cell.textMinLabel.text = promotions[indexPath.row].label1
            cell.textMaxLabel.text = promotions[indexPath.row].label2
        }

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

