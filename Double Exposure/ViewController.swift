//
//  ViewController.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/8/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,
                        UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                        UICollectionViewDelegate {
    
    var leftImage: UIImage? {
        didSet {
            if (leftImage != oldValue) {
                leftButton?.setBackgroundImage(leftImage, for: UIControlState.normal)
            }
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            if (rightImage != oldValue) {
                rightButton?.setBackgroundImage(rightImage, for: UIControlState.normal)
            }
        }
    }
    
    var composedImage: UIImage? {
        didSet {
            if (composedImage != oldValue) {
                imageView?.image = composedImage
            }
        }
    }
    
    let dataSource = EffectListDS()
    
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var collectionView: UICollectionView?
    
    @IBOutlet weak var leftButton: UIButton?
    @IBOutlet weak var rightButton: UIButton?
    @IBOutlet weak var shareButton: UIButton?
    
    var buttonPressed: UIButton?
        
    @IBAction public func tappedButton(_ button: UIButton) {
        buttonPressed = button
        
        PHPhotoLibrary.requestAuthorization { (auth) in
            if (auth == PHAuthorizationStatus.authorized) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(picker, animated: true, completion:nil)
           }
        }
    }
    
    @IBAction public func swapImages(_ button: UIButton) {
        if (leftImage != nil && rightImage != nil) {
            let temp = leftImage
            leftImage = rightImage
            rightImage = temp
            
            updateImage()
        }
    }
    
    @IBAction public func share(_ button: UIButton) {
        if let image = composedImage {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }

    }

    private func configureButton(_ button: UIButton?) {
        if let b=button {
            let layer = b.layer
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("mode-changed"), object: nil, queue: nil) { (n) in
                self.updateImage()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("alpha-changed"), object: nil, queue: nil) { (n) in
                self.updateImage()
        }
        
        collectionView?.dataSource = dataSource
        
        configureButton(leftButton)
        configureButton(rightButton)
        configureButton(shareButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateImage() -> Void {
        self.composedImage = ImageComposer.instance.compose(self.leftImage,self.rightImage)
    }
    
    // image picker delegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        guard let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL else {
            return
        }
        
        // Handle picking a Photo from the Photo Library
        let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
        let asset = assets.firstObject
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
            guard let url = contentEditingInput?.fullSizeImageURL else {
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            if (self.buttonPressed === self.leftButton) {
                self.leftImage = UIImage(data: data)
            } else {
                self.rightImage = UIImage(data: data)
            }
            self.updateImage()
            
        })
        
    }
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let effect = dataSource[indexPath.row]
        ImageComposer.instance.setImageEffect(effect)
    }
    
    // collection view data source

}

