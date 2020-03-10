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
    var containerHeight: CGFloat = 0
    private var totalCellsHeight: CGFloat = 0
    
    // Алгоритм размещения
    override func prepare() {
        
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        
        let photoCounter = collectionView.numberOfItems(inSection: 0)
        guard photoCounter > 0 else { return }
        
        // Необходимое количество строк при известном максимальном значении колонок
        let numOfRows = ceil(CGFloat(photoCounter) / CGFloat(maxColumns))
        cellHeight = collectionView.frame.height / numOfRows
        
        var lastX: CGFloat = 0
        var lastY: CGFloat = 0
        
        // Запускаем цикл прохода по всем фотографиям
        for i in 0..<photoCounter {
            var cellWidth: CGFloat = 0
            let indexPath = IndexPath(item: i, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Если строка не последняя, делим на количество столбцов
            // Если последняя, то делим на оставшиеся количество фотографий
            if ceil(CGFloat(i + 1) / CGFloat(maxColumns)) < numOfRows || photoCounter % maxColumns == 0 {
                cellWidth = collectionView.frame.width / CGFloat(maxColumns)
            } else {
                cellWidth = collectionView.frame.width / CGFloat(photoCounter % maxColumns)
            }
            
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
