
//  RoundedImage.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/8/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.size.height / 2
        layer.borderWidth = 3
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
    }
}
