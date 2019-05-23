//
//  ViewControllerRecord.swift
//  Market Place
//
//  Created by Jose Soarez on 5/19/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewControllerRecord: UIViewController {

    let modelRecordController = RecordModelManager.sharedModelManager
    let modelController = ModelManager.sharedModelManager
    var carts : [Cart] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print (modelController.token)
        RecordModelManager.getCartsFromApi(token: modelController.token, completionHandler: {response, error in
            if let response = response{
                self.carts = response
                self.tableView.reloadData()
            }
        })
        
        // Do any additional setup after loading the view.
    }

}

extension ViewControllerRecord: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(carts.isEmpty){
            return 1
        }else{
            return carts.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! TableViewCellRecord
       /* let product = ModelManager.getProductForCategory(caregoryIndex: indexPath.section, listOfProducts: products)*/
        if(carts.isEmpty){
            cell.dateLabel.text = "Loading..."
            cell.totalPriceLabel.text = ""
        }else{
            cell.dateLabel.text = carts[indexPath.row].date
            let totalPrice = Cart.getTotal(carts[indexPath.row])
            cell.totalPriceLabel.text = "\(totalPrice)"
        }
        return cell
        
    }
}
