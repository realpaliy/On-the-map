//
//  ButtonVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/20/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

@IBDesignable class ButtonVC: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
