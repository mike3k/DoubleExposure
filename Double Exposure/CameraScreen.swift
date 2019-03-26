//
//  CameraScreen.swift
//  Double Exposure
//
//  Created by Mike Cohen on 10/3/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit
import Photos

class CameraScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var image : UIImage?
    var shouldShowCamera : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if (shouldShowCamera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            
            self.present(picker, animated: true, completion:nil)
            shouldShowCamera = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion:nil)
        
        guard let photoReferenceUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL else {
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
            self.image = UIImage(data:data)
            self.performSegue(withIdentifier: "MainScreen", sender: self)
        })
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as? MainViewController
        vc?.leftImage = self.image
    }
    

}
