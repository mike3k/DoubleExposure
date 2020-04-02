//
//  ImageEffect.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/14/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit

struct ImageEffect {
    let name : String
    let mode : CGBlendMode
    let alpha : CGFloat
    var icon : UIImage?
    
    init(name : String, mode : CGBlendMode, alpha : CGFloat) {
        self.name = name
        self.mode = mode
        self.alpha = alpha
    }
}
