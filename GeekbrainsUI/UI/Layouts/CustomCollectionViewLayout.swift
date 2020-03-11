//
//  CustomCollectionViewLayout.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 14/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

enum CollectionCustomSize {
    case small
    case wide
}
class CustomCollectionViewLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() //сохраняет в себе информацию о каждой из ячеек - как она рендерится и т.д.
    var columns = 2
    var cellHeight = 200
    var containerHeight: CGFloat = 0 //высота контента
    
    init (numberColumns: Int, cellHeight: Int) {
        super.init()
        
        self.columns = numberColumns
        self.cellHeight = cellHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collection = collectionView else{
            return
        }
        let itemsCount = collection.numberOfItems(inSection: 0) //суммарное кол-во ячеек в коллекции
        guard itemsCount > 0 else {return}
        
        let commonWidth = collection.frame.width // ширина широкой ячейки
        let smallWidth = collection.frame.width / CGFloat(columns) //ширина узкой ячейки
        
        
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for element in 0..<itemsCount {
            let indexPath = IndexPath(item: element, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isWide: CollectionCustomSize = (element + 1) % (columns + 1) == 0 ? .wide : .small //на четной позиции - широкая ячейка, на нечетной - узкая ячейка
            
            switch isWide{
            case .wide:
                attributeForIndex.frame = CGRect(x: CGFloat(0),
                                                 y: y,
                                                 width: commonWidth,
                                                 height: CGFloat(cellHeight))
                y += CGFloat(cellHeight) //если широкая ячейка - добавляем Y => следующая ячейка будет ниже
                
            case .small:
                attributeForIndex.frame = CGRect(x: x,
                                                 y: y,
                                                 width: smallWidth,
                                                 height: CGFloat(cellHeight))
                
                //для узкой ячейки проверяем: первая она или вторая в ряду. Для первой не нужно добавлять Y к следующей ячейке, т.к. две узкие ячейки помещаются на одном уровне
                if (element + 2) % (columns + 1) == 0 || element == itemsCount - 1{
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else{
                    x += smallWidth
                }
                
            }
            
            cacheAttributes[indexPath] = attributeForIndex
        }//for
        
        containerHeight = y
        
    }// func prepare()
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter{
            rect.intersects($0.frame)
        }
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: collectionView?.frame.width ?? 0, height: containerHeight)
    }
    
}//class CustomCollectionViewLayout
