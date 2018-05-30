import UIKit
import Contacts

class TutorialViewController: UIViewController,PageViewControllerDelegate
{
    @IBOutlet weak var headerView: HeaderView!

    // Mark - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoardSegue.showImagesViewController {
            if let pagesVC = segue.destination as? ContainerViewController{
                pagesVC.cdelegate = headerView
            }
        }
    }
    
    // Mark - PageViewControllerDelegate
    
    func setupPageController(numPages: Int) {
        
    }
    
    func turnPageController(to index: Int) {
        
    }
  
}
