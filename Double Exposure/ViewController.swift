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
    
    let effectList: [ImageEffect] = [ImageEffect(name: "Normal",mode: CGBlendMode.normal,alpha: 0.5),
                                     ImageEffect(name: "Overlay",mode: CGBlendMode.overlay,alpha: 0.5),
                                     ImageEffect(name: "Darken",mode: CGBlendMode.darken,alpha: 0.5),
                                     ImageEffect(name: "Lighten",mode: CGBlendMode.lighten,alpha: 0.5)]
    
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
                        self.updateImage()
                    }
                }
            })
        }
    }
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: handle selection
        let effect = effectList[indexPath.row];
        ImageComposer.instance.setImageEffect(effect)
    }
    
    // collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return effectList.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // TODO: configure cell
        cell.backgroundColor = UIColor.white
        return cell
    }

}

