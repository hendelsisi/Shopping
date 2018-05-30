
//  IconCollectionViewCell.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/6/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgIcon.layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
}
