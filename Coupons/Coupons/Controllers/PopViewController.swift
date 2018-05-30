
//  PopViewController.swift
//  Arabian Center
//
//  Created by hend elsisi on 4/2/18.
//  Copyright © 2018 hend elsisi. All rights reserved.
//

import UIKit
import MaryPopin

class PopViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func close(_ sender: Any) {
        parent?.dismissCurrentPopinController(animated: true)
    }
    @IBAction func getGifts(_ sender: Any) {
         parent?.dismissCurrentPopinController(animated: true)
    }
}
