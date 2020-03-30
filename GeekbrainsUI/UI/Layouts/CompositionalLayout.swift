//
//  CompositionalLayout.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 26/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//
import UIKit

class MyCompositionalLayout{
       func createCarouselLayout() -> UICollectionViewLayout {
        //размер элемента в группе. Высота - 100% ячейки, ширина - 50:
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                 heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //отступы между элементами
           item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        //размер горизонтальной группы. Для карусели - 100% высоты и ширины ячейки
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                            subitems: [item])
// секция. В нашем случае одна и из одной группы
           let section = NSCollectionLayoutSection(group: group)
        //задаем внутри нее горизонтальный скроллинг
           section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//возвращаем layout из указанных свойств
           let layout = UICollectionViewCompositionalLayout(section: section)
           return layout
       }
    
    
    func createBigLeftAllOtherRoundLayout() -> UICollectionViewLayout{
//          _______
//          |   |_|
//          |___|_|
//          |_|_|_|
//          |_|_|_|

        let localInset = CGFloat(1.0)
        
        //левый верхний большой элемент
        //ширина равна высоте и ширина равна ширине группы
        let topLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        topLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: localInset, leading: localInset, bottom: localInset, trailing: localInset)
        
        //элементы под большим элементом (2)
        //ширина и высота - половина большого
        let middleLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        middleLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: localInset, leading: localInset, bottom: localInset, trailing: localInset)
        let middleLeadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)), subitems: [middleLeadingItem])
        
        //нижняя строка слева
        let bottomLeadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        bottomLeadingItem.contentInsets = NSDirectionalEdgeInsets(top: localInset, leading: localInset, bottom: localInset, trailing: localInset)
        
        //группа из двух элементов выше
        let bottomLeadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)), subitems: [bottomLeadingItem])
       
        //объединяющая группа всех элементов слева. Одного большого и 2*2  маленьких под ним
        let leftNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6667), heightDimension: .fractionalHeight(1.0)), subitems: [topLeadingItem, middleLeadingGroup, bottomLeadingGroup])
        
        //правый вертикальный элемент, справа от большого
        //размер: ширина - 100% от правой группы, высота - 33%
        let rightVerticalItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        rightVerticalItem.contentInsets = NSDirectionalEdgeInsets(top: localInset, leading: localInset, bottom: localInset, trailing: localInset)
        
        //правая группа из трех элементов
        let rightNestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3334), heightDimension: .fractionalHeight(1.0)), subitems: [rightVerticalItem])
        
        //объединяющая группа
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.2006)), subitems: [leftNestedGroup, rightNestedGroup])

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: localInset, leading: localInset, bottom: localInset, trailing: localInset)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}//class MyCompositionalLayout
