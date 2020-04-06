//
//  NewsPhotoCollectionViewCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 10/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class NewsPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsPhotoImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // в тестовых целях покрасили ячейку! чтобы видно было
        //self.backgroundColor = UIColor.red
        //self.newsPhotoImage.image = UIImage(named: "news1" )
        
    }
    
    func renderCell(imagePath: String) {
        if let url = URL(string: imagePath){
            newsPhotoImage.kf.setImage(with: url)
        }
    }
}
