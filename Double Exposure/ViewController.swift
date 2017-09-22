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
    var leftImage: UIImage?
    var rightImage: UIImage?
    
    var composedImage: UIImage?
    
    let dataSource = EffectListDS()
    
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var collectionView: UICollectionView?
    
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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("mode-changed"), object: nil, queue: nil) { (n) in
                self.updateImage()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("alpha-changed"), object: nil, queue: nil) { (n) in
                self.updateImage()
        }
        
        collectionView?.dataSource = dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateImage() -> Void {
        self.imageView?.image = ImageComposer.instance.compose(self.leftImage,self.rightImage)
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
                self.leftButton?.imageView?.image = self.leftImage
            } else {
                self.rightImage = UIImage(data: data)
                self.rightButton?.imageView?.image = self.rightImage
            }
            self.updateImage()
            
        })
        
    }
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: handle selection
        let effect = dataSource[indexPath.row]
        ImageComposer.instance.setImageEffect(effect)
    }
    
    // collection view data source

}

