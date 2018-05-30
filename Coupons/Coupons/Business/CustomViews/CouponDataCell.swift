
//  CouponDataCell.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/9/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit

class CouponDataCell: UITableViewCell {
    @IBOutlet weak var coup_Brand_img: RoundedImage!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var followBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followBtn.tag = 1
    }

    @IBAction func followAction(_ sender: Any) {
        if (sender as! UIButton).tag == 2 {
            ( sender as! UIButton).tag = 1
            followBtn.setTitle(NSLocalizedString("+ Follow", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
            followBtn.setTitleColor(UIColor.lightGray, for: .normal)
            followBtn.backgroundColor = UIColor.white
        } else {
            if (sender as! UIButton).tag == 1 {
                (sender as! UIButton).tag = 2
                followBtn.setTitle(NSLocalizedString("✓ Following", tableName: "LocalizeFile", bundle: Bundle.main, value: "", comment: ""), for: .normal)
                followBtn.setTitleColor(UIColor.white, for: .normal)
                followBtn.backgroundColor = UIColor.color(fromHexString: "#5b33aa")
                
            }
        }
    }
}
