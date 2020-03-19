//
//  PostAndButton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 12/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class PostAndButton: UITableViewCell {
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var newsTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsTextBottomConstraint: NSLayoutConstraint!
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        
        guard let text = newsText.text else {return}
        let height = text.getHeight(constraintedWidth: newsText.frame.width, font: newsText.font)
        
        if height <= Constants.textRowHeight  {return}
        
        moreText = !moreText
        if moreText{
           //расширяем ячейку
            newsTextHeightConstraint.constant = height
            
            newsTextHeightConstraint.priority = UILayoutPriority(rawValue: 250)
            newsTextBottomConstraint.priority = UILayoutPriority(rawValue: 750)
            
             moreButton.setTitle("Показать меньше", for: .normal)
        }
        else
        {
            //уменьшаем ячейку
            newsTextHeightConstraint.constant = Constants.textRowHeight
          
            newsTextHeightConstraint.priority = UILayoutPriority(rawValue: 750)
            newsTextBottomConstraint.priority = UILayoutPriority(rawValue: 250)
            
              moreButton.setTitle("Показать полностью", for: .normal)
        }
        contentView.layoutIfNeeded()
        self.view?.updateTable()
    }
    
    var moreText: Bool = false
    private weak var view: MessageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderCell(view: MessageView, newstext: String){
        //передаем в ячейку указатель на таблицу, которая будет перерисовываться
        self.view = view
        
        //заполняем текстовое поле
        newsText.text = newstext
        
        //уточняем констрейнт на высоту
        guard let textToMeasure = newsText.text else {return}
        //вычисляем высоту текста для определения констрейнта
        //реализация getHeight - в Extension для String
        let height = textToMeasure.getHeight(constraintedWidth: newsText.frame.width, font: newsText.font)
        
        //  если высота текста меньше константы, то выставляем констрейнт в эту высоту и делаем кнопку невидимой
        if height <= Constants.textRowHeight{
            newsTextHeightConstraint.constant = height
            moreButton.isHidden = true
        } else{
            newsTextHeightConstraint.constant = Constants.textRowHeight
            moreButton.isHidden = false
        }
        
    }//func renderCell
    
}//class
