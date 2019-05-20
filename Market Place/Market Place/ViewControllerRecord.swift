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
        RecordModelManager.getCartsFromApi(token: modelController.token, completionHandler: {response, error in
            if let response = response{
                self.carts = response
            }
            print(self.carts)
        })
        
        // Do any additional setup after loading the view.
    }

}

extension ViewControllerRecord: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! TableViewCellRecord
       /* let product = ModelManager.getProductForCategory(caregoryIndex: indexPath.section, listOfProducts: products)*/
        return cell
        
    }
}
