//
//  FBOperationsHandler.swift
//  Coupons
//
//  Created by hend elsisi on 5/31/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import Foundation

protocol FBOperationsHandler {
    func performFbOperation(successfulOperation:@escaping(Bool)->Void)
  //  func handleFbOperation()//:result
}
