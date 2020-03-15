//
//  PhotoCollectionTableViewCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class PhotoCollectionTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var newsPhotocount: Int?
       var newsPhotoArray: [String]?
    
    @IBOutlet weak var newsPhotoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newsPhotoCollectionView.register(UINib(nibName: "NewsPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsPhotoCell")
        
        self.newsPhotoCollectionView.delegate = self
        self.newsPhotoCollectionView.dataSource = self
        self.newsPhotocount = 0
        self.newsPhotoArray = [String]()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsPhotocount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsPhotoCell", for: indexPath) as? NewsPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
   
        if let image = newsPhotoArray?[indexPath.row] {
            cell.renderCell(imagePath:  image)
        }
        
        return cell
    }
    
    func renderCell ( imagesArray: [String]){
        self.newsPhotocount = imagesArray.count
             self.newsPhotoArray = imagesArray
    }
}
