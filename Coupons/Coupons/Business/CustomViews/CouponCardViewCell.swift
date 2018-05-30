
//  CouponCardViewCell.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/9/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class CouponCardViewCell: UITableViewCell {
    @IBOutlet weak var storePic: RoundedImage!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var getCode: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
