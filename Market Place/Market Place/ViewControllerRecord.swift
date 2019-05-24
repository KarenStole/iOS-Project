//
//  ViewControllerRecord.swift
//  Market Place
//
//  Created by Jose Soarez on 5/19/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class ViewControllerRecord: UIViewController {

    var modelRecordController = RecordModelManager.sharedModelManager
    var modelController = ModelManager.sharedModelManager
    var carts : [Cart] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print (modelController.token)
        carts.removeAll()
        RecordModelManager.getCartsFromApi(token: modelController.token, completionHandler: {response, error in
            if let response = response{
                self.carts = response
                self.tableView.reloadData()
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "An error has occurred getting the purchases. Retry in some minutes", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                print("LOG ERROR: Error getting the purchases: \(error.localizedDescription)")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ViewControllerCart
        destinationVC.modelController = self.modelController
        destinationVC.modelControllerRecord = self.modelRecordController
        destinationVC.isRecordViewController = true
        destinationVC.title = "Details"
        
    }

    
}

extension ViewControllerRecord: UITableViewDelegate, UITableViewDataSource, DetailTableViewCellDelegate{
    
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
            cell.detailButton.isHidden = true
        }else{
            cell.delegate = self
            cell.detailButton.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy HH:mm"
            let myStringafd = formatter.string(from: carts[indexPath.row].date!)
            cell.dateLabel.text = myStringafd
            let totalPrice = carts[indexPath.row].getTotal()
            cell.totalPriceLabel.text = "$\(totalPrice)"
            cell.cartRecord = carts[indexPath.row]
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func goToDetail(cell: TableViewCellRecord) {
        let indexPath = tableView.indexPath(for: cell)
        if let indexPath = indexPath {
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCellRecord
            self.modelRecordController.cart = cell.cartRecord
            performSegue(withIdentifier: "recordSegue", sender: self)
        }
    }
}
