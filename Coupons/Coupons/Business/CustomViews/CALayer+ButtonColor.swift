
//  CALayer+ButtonColor.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/2/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import QuartzCore
import UIKit

extension CALayer {
    func setBorderColorFrom(_ color: UIColor?) {
        borderColor = color?.cgColor
    }
}
