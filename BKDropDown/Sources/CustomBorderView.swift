//
//  CustomBorderView.swift
//  BKDropDown
//
//  Created by moon on 23/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import UIKit

class CustomBorderView: UIView {

    @IBInspectable var cornerRadius :CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor?{
        get{
            return UIColor(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        if self.m_is_circle
        {
            self.cornerRadius = max(rect.width, rect.height)/2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.m_is_circle
        {
            self.cornerRadius = max(bounds.width, bounds.height)/2
        }
    }
    
    //MARK: - Member
    fileprivate var m_is_circle:Bool = false
    
    @IBInspectable var is_circle :Bool{
        get{
            return m_is_circle
        }
        set{
            m_is_circle = newValue
        }
    }
    
}

