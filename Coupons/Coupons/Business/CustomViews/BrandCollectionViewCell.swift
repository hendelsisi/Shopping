
//  BrandCollectionViewCell.swift
//  Arabian Center
//
//  Created by hend elsisi on 3/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var selectionState: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        brandLogo.layer.masksToBounds = true
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.lightGray.cgColor
        let view = UIView(frame: bounds)
        selectedBackgroundView = view
        selectedBackgroundView?.layer.borderWidth = 1
        selectedBackgroundView?.layer.borderColor = UIColor.white.cgColor
    }
}
