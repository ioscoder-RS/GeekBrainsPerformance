//
//  PhotoCollectionTableViewCell.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

protocol ImageHeightDefined {
    func imageHeightDefined()
}


class PhotoCollectionTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var layout: UICollectionViewLayout?
    
    var newsPhotocount: Int?
    var newsPhotoArray: [String]?
    var myCompositionalLayout = MyCompositionalLayout()
    
    @IBOutlet weak var newsPhotoCollectionView: NewsPhotoCollectionView!

    var imageHeightDelegate: ImageHeightDefined?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.newsPhotoCollectionView.register(UINib(nibName: "NewsPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsPhotoCell")
         
         self.newsPhotoCollectionView.delegate = self
         self.newsPhotoCollectionView.dataSource = self
         self.newsPhotocount = 0
         self.newsPhotoArray = [String]()
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
    
    func renderCollection ( imagesArray: [Video], imageCount: Int){
        self.newsPhotocount = imageCount
        self.newsPhotoArray = imagesArray.map{($0.url ?? "")}
        
        //если в массиве больше трех фото, то задаем CompositionalLayout
        
        if (imageCount > 3)&&(Session.shared.appVersion > 13.0){
            self.newsPhotoCollectionView.collectionViewLayout = myCompositionalLayout.createCarouselLayout()
        }
        else{
            self.newsPhotoCollectionView.collectionViewLayout = NewsCellLayout()
        }
    }//if (imageCount > 3)
    
    

}
