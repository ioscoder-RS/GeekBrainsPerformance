//
//  PhotoCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 16/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var cellUsername: UILabel!
    
    func renderCell(model: VKPhotosRealm, username: String ) {
        cellUsername.text = username
        
        let sizesRealm = model.sizes.filter("type == %@","x")
        let urlToBe = sizesRealm[0].url
        let url = URL(string: urlToBe)
        
        photo.kf.setImage(with: url)
    }
}
