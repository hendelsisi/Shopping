//
//  HeaderViewController.swift
//  tryPager
//
//  Created by hend elsisi on 4/18/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class HeaderView: UIView,PageViewControllerDelegate {
    
    @IBOutlet weak var doneBtn:UIButton!
    @IBOutlet weak var pageCont:UIPageControl!
    
    func setupPageController(numPages: Int) {
        pageCont.numberOfPages = numPages
    }
    
    func turnPageController(to index: Int) {
       
        pageCont.currentPage = index
        let lastPage = isLastPage(index: index)
        
        
        if(lastPage)
        {
            doneBtn.isHidden = false
        }
    }
    
    func isLastPage(index:Int) -> Bool {
        return index == 4
    }
    
}
