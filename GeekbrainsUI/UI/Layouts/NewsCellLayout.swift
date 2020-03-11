//
//  NewsCellLayout.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 10/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class NewsCellLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    // Настраиваемые отступы между фото
    @IBInspectable var cellsMarginX: CGFloat = 2.0
    @IBInspectable var cellsMarginY: CGFloat = 2.0
    
    var maxColumns = 50
    var cellHeight: CGFloat = 200
    var cellWidth: CGFloat = 0
    var containerHeight: CGFloat = 0
    private var totalCellsHeight: CGFloat = 0
    
    // Алгоритм размещения
    override func prepare() {
        
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        
        let photoCounter = collectionView.numberOfItems(inSection: 0)
        guard photoCounter > 0 else { return }
        
        // Необходимое количество строк в нашем случае всегда = 1
        let numOfRows = 1
        cellHeight = collectionView.frame.height
        cellWidth = collectionView.frame.width / CGFloat(photoCounter)
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        // Запускаем цикл прохода по всем фотографиям
        for i in 0..<photoCounter {
           
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributeForIndex.frame = CGRect(
                x: lastX,
                y: lastY,
                width: cellWidth,
                height: cellHeight)
            
            if ((i + 1) % maxColumns) == 0 {
                lastY += cellHeight + cellsMarginY
                lastX = 0
            } else {
                lastX += cellWidth + cellsMarginX
            }
            
            cacheAttributes[indexPath] = attributeForIndex
        }
        containerHeight = lastY
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter {
            rect.intersects($0.frame)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0,
                      height: containerHeight)
    }
}
