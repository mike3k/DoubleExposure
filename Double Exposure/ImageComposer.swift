//
//  ImageComposer.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/13/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit

class ImageComposer: NSObject {
    static let instance = ImageComposer();
    
    var mode = CGBlendMode.normal {
        didSet {
            if (mode != oldValue) {
                // notify of changed value
                NotificationCenter.default.post(name: NSNotification.Name("mode-changed"), object: mode)
            }
        }
    }
    
    var alpha: CGFloat = 0.5 {
        didSet {
            if (alpha != oldValue){
                // notify of changed value
                NotificationCenter.default.post(name: NSNotification.Name("alpha-changed"), object: alpha)
            }
        }
    }
    
    func setImageEffect(_ effect : ImageEffect) -> Void {
        self.mode = effect.mode
        self.alpha = effect.alpha
    }
    
    func compose(_ image1 : UIImage?, _ image2 : UIImage?) -> UIImage? {
        if (image1 != nil) && (image2 == nil) {
            return image1
        } else if (image2 != nil) && (image1 == nil) {
            return image2
        } else {
            return blend(image1!,image2!)
        }
    }
    
    func blend(_ image1 : UIImage, _ image2 : UIImage) -> UIImage {
        
        let newSize = image1.size
        UIGraphicsBeginImageContext( newSize )
        
        image1.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height))
        
        image2.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height),
                    blendMode:mode, alpha:alpha)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return newImage
    }
}
