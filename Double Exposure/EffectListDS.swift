//
//  EffectListDS.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/22/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit

class EffectListDS: NSObject, UICollectionViewDataSource {

    var selectedItem : Int = -1
//    {
//        didSet {
//            // highlight selected item
//        }
//        willSet {
//            if (newValue != selectedItem) {
//                // deselect item
//            }
//        }
//    }
    
    private let effects: [ImageEffect] = [ImageEffect(name: "Normal",mode: CGBlendMode.normal,alpha: 0.5),
                                     ImageEffect(name: "Overlay",mode: CGBlendMode.overlay,alpha: 1.0),
                                     ImageEffect(name: "Darken",mode: CGBlendMode.darken,alpha: 1.0),
                                     ImageEffect(name: "Lighten",mode: CGBlendMode.lighten,alpha: 1.0),
                                     ImageEffect(name: "Mult", mode: CGBlendMode.multiply, alpha: 1.0),
                                     ImageEffect(name: "Diff",mode: CGBlendMode.difference,alpha: 1.0),
                                     ImageEffect(name: "Dodge", mode: CGBlendMode.colorDodge, alpha: 1.0),
                                     ImageEffect(name: "Burn", mode: CGBlendMode.colorBurn, alpha: 1.0),
                                     ImageEffect(name: "Screen", mode: CGBlendMode.screen, alpha: 1.0),
//                                     ImageEffect(name: "Hue", mode: CGBlendMode.hue, alpha: 1.0),
//                                     ImageEffect(name: "Saturation", mode: CGBlendMode.saturation, alpha: 1.0),
//                                     ImageEffect(name: "Luminosity", mode: CGBlendMode.luminosity, alpha: 1.0),
//                                     ImageEffect(name: "Color", mode: CGBlendMode.color, alpha: 1.0),

    ]


    func count() -> Int {
        return effects.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return effects.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EffectCell
        // TODO: configure cell
        let effect = effects[indexPath.row]
        cell.isSelected = (indexPath.row == selectedItem)
        cell.label?.text = effect.name
        cell.label?.textColor = UIColor.white;
        cell.label?.textAlignment = .center;
        cell.imageView?.image = UIImage.init(named: effect.name)
        cell.highlight()
        return cell
    }

    subscript(index: Int) -> ImageEffect {
        return effects[index]
    }
    
}
