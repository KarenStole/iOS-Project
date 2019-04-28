//
//  ViewController.swift
//  Market Place
//
//  Created by Jose Soarez on 4/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let modelController = ModelController()
    var categories : [String] = []
    var products : [Product] = []
    var searchProduct = [String]()
    var searchActive : Bool = false
    var buttonAddStatusFormCells: [[Bool]] = []
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func getListOfProducts(_ sender: Any) {
        print (modelController.getProductsFromFile())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = modelController.getProductCategoryFromFile()
        products = modelController.getProductsFromFile()
        showPromotionImagesOnScrollView()
        for category in 0..<categories.count{
            self.buttonAddStatusFormCells.append(Array(repeating: false, count: modelController.getProductForCategory(caregoryIndex: category).count))
        }
        pageControl.numberOfPages = getPromotionImages().count
    }
    
    @IBAction func showHideButton(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        buttonAddStatusFormCells[(indexPath?.section)!][(indexPath?.row)!] = true
        self.tableView.reloadData()
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return categories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.searchActive){
            var count = 0
            let products = modelController.getProductForCategory(caregoryIndex: section)
            let productsNames = modelController.getProductsName(products: products)
            for index in 0..<searchProduct.count{
                if(productsNames.contains(searchProduct[index])){
                        count+=1
                        
                    }
                }
            return count
            }
        
        else{
            return modelController.getProductForCategory(caregoryIndex: section).count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableView", for: indexPath) as! TableViewCell
        cell.tableView = self.tableView
        let product = modelController.getProductForCategory(caregoryIndex: indexPath.section)
        if(searchActive){
            for prod in  product{
                for prodNameSearched in self.searchProduct{
                print("\(product[indexPath.row].getProductName()):\(prodNameSearched)" )
                if(prod.getProductName() == prodNameSearched){
                    print("entro")
                    cell.productNameLaber.text = prod.getProductName()
                    cell.productPriceLaber.text = "$\(prod.getProductPrice())"
                    cell.productPictureImageView.image = prod.getProductImage()
                    cell.showAddButton = self.buttonAddStatusFormCells[indexPath.section][indexPath.row]
                    cell.showPlusMinButton = !self.buttonAddStatusFormCells[indexPath.section][indexPath.row]
                }
            }
            }
        }
        else{
            cell.productNameLaber.text = product[indexPath.row].getProductName()
            cell.productPriceLaber.text = "$\(product[indexPath.row].getProductPrice())"
            cell.productPictureImageView.image = product[indexPath.row].getProductImage()
            cell.showAddButton = self.buttonAddStatusFormCells[indexPath.section][indexPath.row]
            cell.showPlusMinButton = !self.buttonAddStatusFormCells[indexPath.section][indexPath.row]
        }

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, commit editingstyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        /*if editingstyle == .delete {
            deleteCell(indexPath: indexPath)
            
        }*/
    }

    
}
extension ViewController : UIScrollViewDelegate{
    
    func getPromotionImages() -> [UIImage] {
        return modelController.getPromotionsImages()
    }
    
    func showPromotionImagesOnScrollView() {
        
        let images = getPromotionImages()
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

extension ViewController : UISearchBarDelegate{
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchProduct = modelController.getProductsName(products: self.products).filter({ $0.prefix(searchText.count) == searchText })
    if(searchProduct.count != self.products.count){
        searchActive = true}
    else{
        searchActive = false}
    self.tableView.reloadData()
    }
    
}

