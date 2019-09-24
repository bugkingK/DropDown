//
//  ViewController.swift
//  BKDropDown
//
//  Created by moon on 23/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vwDropDownLeft: UIView!
    @IBOutlet weak var vwDropDownRight: UIView!
    
    @IBOutlet weak var lbDropDownLeft: UILabel!
    @IBOutlet weak var lbDropDownRight: UILabel!
    
    private var dropDownLeft:BKDropDown!
    private var dropDownRight:BKDropDown!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
        setupDropDown()
    }
    
    fileprivate func setupLayout() {
        vwDropDownLeft.layer.cornerRadius = 5
        vwDropDownLeft.layer.masksToBounds = true
        vwDropDownRight.layer.cornerRadius = 5
        vwDropDownRight.layer.masksToBounds = true
    }
    
    fileprivate func setupDropDown() {
        dropDownLeft = BKDropDown.instance()
            .bind(["Item 1", "Item 2", "Item 3", "Item 4"])
            .setLayoutCell(normal: .white, highlight: .lightGray,height: 50)
            .setLayoutTitle(normal: .darkGray, highlight: .darkGray ,font: UIFont.systemFont(ofSize: 14))
            .setPadding(leading: 20, trailing: 20)
            .setDidSelectRowAt({ (_, item, dropDown) in
                self.lbDropDownLeft.text = item.title
                dropDown.hide()
            })
        
        dropDownRight = BKDropDown.instance()
            .bind(["Item 1", "Item 2", "Item 3", "Item 4"])
            .setLayoutCell(normal: .white, highlight: .lightGray, height: 50)
            .setLayoutTitle(normal: .darkGray, highlight: .darkGray ,font: UIFont.systemFont(ofSize: 14))
            .setPadding(leading: 20, trailing: 20)
            .setDidSelectRowAt({ (_, item, dropDown) in
                self.lbDropDownRight.text = item.title
                dropDown.hide()
            })
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        if sender.tag == 0 {
            dropDownLeft
                .setLayoutCell(width:sender.frame.width - 10)
                .show(self, targetView: sender)
        } else {
            dropDownRight.show(self, targetView: sender)
        }
    }
    
}

