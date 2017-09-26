//
//  EffectListDS.swift
//  Double Exposure
//
//  Created by Mike Cohen on 9/22/17.
//  Copyright © 2017 Mike Cohen. All rights reserved.
//

import UIKit

class EffectListDS: NSObject, UICollectionViewDataSource {

    private let effects: [ImageEffect] = [ImageEffect(name: "Normal",mode: CGBlendMode.normal,alpha: 0.5),
                                     ImageEffect(name: "Overlay",mode: CGBlendMode.overlay,alpha: 1.0),
                                     ImageEffect(name: "Darken",mode: CGBlendMode.darken,alpha: 1.0),
                                     ImageEffect(name: "Lighten",mode: CGBlendMode.lighten,alpha: 1.0),
                                     ImageEffect(name: "Difference",mode: CGBlendMode.difference,alpha: 1.0),
                                     ImageEffect(name: "Dodge", mode: CGBlendMode.colorDodge, alpha: 1.0),
                                     ImageEffect(name: "Burn", mode: CGBlendMode.colorBurn, alpha: 1.0),
    ]


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
        cell.backgroundColor = UIColor.white
        cell.label?.text = effect.name
        cell.imageView?.image = UIImage.init(named: effect.name)
        return cell
    }

    subscript(index: Int) -> ImageEffect {
        return effects[index]
    }
    
}
