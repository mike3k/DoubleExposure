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
                        UICollectionViewDelegate, UICollectionViewDataSource {
    var leftImage: UIImage?
    var rightImage: UIImage?
    
    var composedImage: UIImage?
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // image picker delegate
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
                        self.imageView?.image = ImageComposer.instance.compose(self.leftImage,self.rightImage)
                    }
                }
            })
        }
    }
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: handle selection
    }
    
    // collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // TODO: configure cell
        return cell
    }

}

