
//
//  Created by hend elsisi on 3/28/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class StoresViewController: UIViewController {
    @IBOutlet weak var stores: UICollectionView!
    var allBrands : Array<String> = []
    var selectState : Array<String> = []

    @IBAction func goHome(_ sender: Any) {
        
          let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "coupons") as? HomeViewController
      
        self.completionhandler_push(home!, animated: true) {

        }
    }
    
    func completionhandler_push(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navigationController?.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stores?.dataSource = self
        self.stores?.delegate = self
        initData()
    }
// MARK: fill data to array for the collection view
    func initData() {
        for i in 0..<20 {
            let imageName = "stores_screen_img\(i + 1)"
            allBrands.append(imageName)
             selectState.append("stores_screen_deselect")
        }
    }
}

// MARK::UICollectionViewDelegate , UICollectionViewDataSource
extension StoresViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCell.brandCell, for: indexPath) as? BrandCollectionViewCell
        cell?.brandLogo.image = UIImage(named: (allBrands[indexPath.item]))
        cell?.selectionState.imageView?.image = UIImage(named: selectState[indexPath.item])
                if let aCell = cell {
                    return aCell
                }
         return UICollectionViewCell()
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let cell = collectionView.cellForItem(at: indexPath) as? BrandCollectionViewCell
                if (selectState[indexPath.item] == "stores_screen_checked") {
                    cell?.selectionState.imageView?.image = UIImage(named: "stores_screen_deselect")
                    selectState[indexPath.item] = "stores_screen_deselect"
                } else {
                    cell?.selectionState.imageView?.image = UIImage(named: "stores_screen_checked")
                    selectState[indexPath.item] = "stores_screen_checked"
                }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        stores.reloadData()
    }
}
