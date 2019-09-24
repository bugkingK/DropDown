//
//  ViewController.swift
//  BKDropDown
//
//  Created by moon on 23/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dropDown:BKDropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let items = ["1dfkefjoefjo", "2", "3", "4", "5"]
        dropDown = BKDropDown.new
            .bind(items, first: 4)
            .setLayoutOfCell(.black, height: 50)
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        dropDown.show(self, targetView: sender)
    }
    
}

