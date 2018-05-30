//
//  PageViewController.swift
//  tryPager
//
//  Created by hend elsisi on 4/18/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
   
    @IBOutlet weak var pageView: UIImageView!
    var image:UIImage?{
        didSet{
            self.pageView?.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.setTutorialImage()
    }
    
    //Mark - Set Image
    func setTutorialImage(){
        self.pageView.image = self.image;
    }
    
}


