//
//  NewsPhotoCollectionView.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 11/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

//Пока не работает!!!
//Цели создания две:
//1. реализовать настраиваемую высоту collectionView
//2. реализовать горизонтальный скроллинг

class NewsPhotoCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
       // return self.collectionViewLayout.collectionViewContentSize
        return contentSize
    }
    

//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout){
//        super.init (frame: frame, collectionViewLayout: layout)
//        setFlowLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init (coder: coder)
//        setFlowLayout()
//    }
//
//    func setFlowLayout(){
////        let flowLayout = UICollectionViewFlowLayout()
////        flowLayout.scrollDirection = .horizontal
////        collectionViewLayout = flowLayout
//    }
}
