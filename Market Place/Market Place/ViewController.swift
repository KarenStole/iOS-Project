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
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPromotionImagesOnScrollView()
    }


}

extension ViewController{
    
    func getPromotionImages() -> [UIImage] {
        return modelController.getPromotionsImages()
    }
    
    func showPromotionImagesOnScrollView() {
        
        let images = getPromotionImages()
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = scrollView.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
            
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
    }
}

