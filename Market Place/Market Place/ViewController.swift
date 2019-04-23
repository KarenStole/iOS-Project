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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func getListOfProducts(_ sender: Any) {
        print (modelController.getProductsFromFile())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPromotionImagesOnScrollView()
        pageControl.numberOfPages = getPromotionImages().count
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

