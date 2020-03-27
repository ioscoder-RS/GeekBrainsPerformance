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
         if imageCount > 3
         {
              self.newsPhotoCollectionView.collectionViewLayout = createLayout()
         }
         else{
             self.newsPhotoCollectionView.collectionViewLayout = NewsCellLayout()
         }
        
//        contentView.layoutIfNeeded()
        //передаем контроллеру событие, что размер изображений определен, чтобы он перерисовался
//        self.imageHeightDelegate?.imageHeightDefined()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
 //       item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
