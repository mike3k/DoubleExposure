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
        return blend(image1,image2,mode:self.mode,alpha:self.alpha)
    }
    
    func blend(_ image1 : UIImage, _ image2 : UIImage, mode: CGBlendMode, alpha: CGFloat) -> UIImage {
        let size1 = image1.size, size2 = image2.size;
        var rect : CGRect
        if (size1.width < size2.width || size1.height < size2.height) {
            rect = CGRect(x: 0, y: 0, width: size1.width, height: size1.height)
        } else {
            rect = CGRect(x: 0, y: 0, width: size2.width, height: size2.height)
        }
        
        UIGraphicsBeginImageContext( rect.size )
        image1.draw(in: rect)
        image2.draw(in: rect, blendMode:mode, alpha:alpha)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return newImage
    }
}
