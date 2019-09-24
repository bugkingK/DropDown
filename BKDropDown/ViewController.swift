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
        dropDown = BKDropDown.instance()
            .bind(["하이", "안녕", "반가워", "하하"], first: 2)
            .setViewLayer(cornerRadius: 5)
            .setLayoutCell(visibleItems: 2, divisionColor: .blue)
            .setLayoutCell(normal: .white, height: 50)
            .setLayoutTitle(normal:.black, highlight:.white ,font: UIFont.systemFont(ofSize: 15), alignment: .center)
            .setPadding(top: 10, bottom: 10)
            .setDidSelectRowAt({ (idx, dropDown) in
                dropDown.hide()
            })
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        dropDown.show(self, targetView: sender)
    }
    
}

