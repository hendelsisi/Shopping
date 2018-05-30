
//  CouponTableViewCell.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/8/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var storeImageView: RoundedImage!
    @IBOutlet weak var cellHeader: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
}
