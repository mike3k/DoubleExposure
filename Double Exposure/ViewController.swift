//
//  ViewController.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/8/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var leftImage: UIImage?
    var rightImage: UIImage?
    
    var composedImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var leftButton: UIButton?
    @IBOutlet weak var rightButton: UIButton?
    
    var buttonPressed: UIButton?
    
    @IBAction public func tappedButton(_ button: UIButton) {
        buttonPressed = button
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(picker, animated: true, completion:nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                if let url = contentEditingInput?.fullSizeImageURL {
                    if let data = try? Data(contentsOf: url) {
                        if (self.buttonPressed === self.leftButton) {
                            self.leftImage = UIImage(data: data)
                            self.leftButton?.imageView?.image = self.leftImage
                        } else {
                            self.rightImage = UIImage(data: data)
                            self.rightButton?.imageView?.image = self.rightImage
                        }
                        self.composeImage()
                    }
                }
            })
        }
    }
    
    func composeImage() {
        if (leftImage != nil) && (rightImage == nil) {
            imageView?.image = leftImage
        } else if (rightImage != nil) && (leftImage == nil) {
            imageView?.image = rightImage
        } else {
            imageView?.image = blendImage(leftImage!, rightImage!)
        }
    }
    
    func blendImage(_ image1 : UIImage, _ image2 : UIImage) -> UIImage {
        let newSize = image1.size
        UIGraphicsBeginImageContext( newSize )
        
        image1.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height))
        
        image2.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height),
                    blendMode:CGBlendMode.normal, alpha:0.5)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return newImage
    }
}

