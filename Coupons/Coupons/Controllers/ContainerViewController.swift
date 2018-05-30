//
//  ContainerViewController.swift
//  Converted
//
//  Created by hend elsisi on 4/18/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit


protocol PageViewControllerDelegate:class {
    func setupPageController(numPages:Int)
    func turnPageController(to index:Int)
}

class ContainerViewController: UIPageViewController {

    weak var cdelegate:PageViewControllerDelegate?
    
    var images : Array<UIImage> = [UIImage (named: "tutorial_screen_img1")!,UIImage (named: "tutorial_screen_img2")!,UIImage (named: "tutorial_screen_img3")!,UIImage (named: "tutorial_screen_img4")!,UIImage (named: "tutorial_screen_img5")!]
    
    lazy var controllers:[UIViewController] = {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        var controllers = [UIViewController]()
        
        for image in images{
            let pageVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryBoardSegue.imagesViewContainer)
            controllers.append(pageVC)
        }
        
        self.cdelegate?.setupPageController(numPages:controllers.count)
        
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControllerDelegate()
        self.turnToPage(index:0)
    }
    
    func pageControllerDelegate() {
        dataSource = self
        delegate = self
    }
    
    func turnToPage(index:Int) {
        let controller = controllers[index]
        
        let direction =  configureDirection(index: index, controller: controller)
        self.configureDisplaying(viewController:controller)
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDirection(index:Int,controller:UIViewController) -> UIPageViewControllerNavigationDirection  {
       
        var direction = UIPageViewControllerNavigationDirection.forward
        if let currntVC = viewControllers?.first{
            let currentIndex = controllers.index(of: currntVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        return direction
    }
    
    func configureDisplaying(viewController:UIViewController) {
        for(index,vc) in controllers.enumerated(){
            if(viewController === vc){
                if let content = viewController as? PageViewController{
                    content.image = self.images[index]
                    self.cdelegate?.turnPageController(to: index)
                }
            }
        }
    }
}

// Mark - UIPageViewControllerDataSource

extension ContainerViewController:UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = controllers.index(of:viewController){
            
            let firstPage = isfirstPage(index: index)
            if !firstPage {
                return controllers[index-1]
            }
            
        }
        return controllers.last
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of:viewController){
            let lastPage = islastPage(index: index)
            if !lastPage {
                return controllers[index+1]
            }
        }
        return controllers.first
    }
    
    // Mark - getPageIndex
    func isfirstPage(index:Int) -> Bool {
        return index == 0
    }
    
    func islastPage(index:Int) -> Bool {
        return index == controllers.count-1
    }
    
}

// Mark - UIPageViewControllerDelegate

extension ContainerViewController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.configureDisplaying(viewController: pendingViewControllers.first as! PageViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed
        { self.configureDisplaying(viewController: previousViewControllers.first as! PageViewController )}
    }

}


