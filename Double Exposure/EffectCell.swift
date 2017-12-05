//
//  EffectCell.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/22/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit

class EffectCell: UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView?
    @IBOutlet weak var label : UILabel?
    
    func highlight() -> () {
        if (self.isSelected) {
            layer.borderWidth = 4.0
            layer.borderColor = UIColor.gray.cgColor
        } else {
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}
