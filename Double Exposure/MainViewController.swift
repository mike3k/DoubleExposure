//
//  MainViewController.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/8/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController,
                        UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                        UICollectionViewDelegate {
    
    var showCameraOnStartup = false
    
    let dataSource = EffectListDS()
    
    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    @IBOutlet weak var leftButton: UIButton?
    @IBOutlet weak var rightButton: UIButton?
    @IBOutlet weak var shareButton: UIButton?
    @IBOutlet weak var swapButton: UIButton?
    
    var buttonPressed: UIButton?

    var leftImage: UIImage? {
        didSet {
            if (leftImage != oldValue) {
                leftButton?.setBackgroundImage(leftImage, for: UIControl.State.normal)
            }
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            if (rightImage != oldValue) {
                rightButton?.setBackgroundImage(rightImage, for: UIControl.State.normal)
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
    
    @IBAction public func clear(_ button: UIButton) {
        self.leftImage = nil;
        self.rightImage = nil;
        self.composedImage = nil;
    }
    
    @IBAction public func tappedButton(_ button: UIButton) {
        buttonPressed = button
        
        let alertController = UIAlertController(title: "Choose a photo",
                                                message: "Take a picture or choose from library",
                                                preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default,
                                                handler: { (action) in
                                                    self.ChooseImage(source: .camera)
        }))
        alertController.addAction(UIAlertAction(title: "Choose from library",
                                                style: UIAlertAction.Style.default,
                                                handler: { (action) in
                                                    self.ChooseImage(source: .photoLibrary)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController,animated: true,completion: nil)
    }
    
    func ChooseImage(source: UIImagePickerController.SourceType = .photoLibrary) {
        PHPhotoLibrary.requestAuthorization { (auth) in
            if (auth == PHAuthorizationStatus.authorized) {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = source
                    self.present(picker, animated: true, completion:nil)
                }
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
            vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?,
                                                completed: Bool,
                                                returnedItems: [Any]?,
                                                error: Error?) -> Void in
                if completed == true {
                    self.showToast(message: "Done")
                }
            }
            present(vc, animated: true, completion: nil)
        }

    }

    private func configureButton(_ button: UIButton?) {
        if let b=button {
            let layer = b.layer
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
            layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("mode-changed"), object: nil, queue: nil) { (n) in
//                self.updateImage()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("alpha-changed"), object: nil, queue: nil) { (n) in
//                self.updateImage()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
            
        collectionView?.dataSource = dataSource
        
        if #available(iOS 11.0, *) {
            self.view.accessibilityIgnoresInvertColors = true
        };
        
        configureButton(leftButton)
        configureButton(rightButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (showCameraOnStartup) {
            showCameraOnStartup  = false
            tappedButton(leftButton!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateImage() -> Void {
        self.composedImage = ImageComposer.instance.compose(self.leftImage,self.rightImage)
    }
    
    private func saveimage(_ image: UIImage?) {
        
        if (buttonPressed === leftButton) {
            leftImage = image
        } else {
            rightImage = image
        }
        
        updateImage()
    }
    
    // image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            if let data = try? Data(contentsOf: imageUrl) {
                self.saveimage(UIImage(data: data))
                return
            }
        }
        
    }
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        dataSource.selectedItem = -1

        if (indexPath.row >= 0 && indexPath.row < dataSource.count()) {
            if let cell = collectionView.cellForItem(at: indexPath) as? EffectCell {
                cell.isSelected = false;
                cell.setNeedsDisplay();
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (dataSource.selectedItem >= 0 && dataSource.selectedItem != indexPath.row) {
            let oldSelection = IndexPath(row:dataSource.selectedItem,section:0)
            if let oldcell = collectionView.cellForItem(at: oldSelection) as? EffectCell {
                oldcell.isSelected = false
                oldcell.setNeedsDisplay();
            }
        }
        
        dataSource.selectedItem = indexPath.row

        let cell = collectionView.cellForItem(at: indexPath) as! EffectCell
        cell.isSelected = true;

        let effect = dataSource[indexPath.row]
        ImageComposer.instance.imageEffect = effect
        updateImage()
    }
    
    // collection view data source

}

