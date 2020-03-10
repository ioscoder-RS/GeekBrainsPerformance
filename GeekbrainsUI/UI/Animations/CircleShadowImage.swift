//
//  CircleShadowImage.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 08/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class CircleShadowImage : UIView{
    var image: UIImageView!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
    }
    
    func addImage(){
        image = UIImageView(frame: frame)
        addSubview(image)
    }
    
    override func layoutSubviews() {
        image.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        image.layer.cornerRadius = bounds.size.height / 2
        image.layer.masksToBounds = true
        
    }
}//class

    /*
 //функция скругляет прямоугольник у фото и добавляет тень
    func roundAndShadowCell (cell:FriendCell){

        //настройки для тени
        let width: CGFloat = 75 //ширина рисунка
          let height: CGFloat = 75 //высота рисунка
          let contactRect = CGRect(x: 0, y: 20, width: width, height: height) //прямоугольник тени. Смещаем на 20 пунктов вниз
 
        //задаем параметры View, в которой будет жить тень. Сама view задана в классе FriendCell
              cell.myShadowView.clipsToBounds = false //тень иначе не работает
              cell.myShadowView.layer.shadowColor = UIColor.black.cgColor //цвет тени - черный
              cell.myShadowView.layer.shadowOpacity = 0.4 //прозрачность
              cell.myShadowView.layer.shadowOffset = CGSize.zero //смещение = 0
              cell.myShadowView.layer.shadowRadius = 10
              // cell.myShadowView.backgroundColor = UIColor.link//фон такой же, как у рисунка
              cell.myShadowView.layer.shadowPath =  UIBezierPath(roundedRect: contactRect, cornerRadius: 35).cgPath //устанавливаем тень по координатам заданного прямоугольника ContactRect
                cell.myShadowView.layer.borderWidth = 0
        //cell.myShadowView.layer.borderColor = UIColor.link.cgColor

              //кусок про скругленные углы.

              //Все операции выполняем на  view из-под рисунка

              cell.userimage.layer.cornerRadius = 35
              cell.userimage.clipsToBounds = true //возвращаем true чтобы скругленный прямоугольник получился
              cell.userimage.layer.borderWidth = 3
              cell.userimage.layer.borderColor = UIColor.white.cgColor
            cell.myShadowView.addSubview(cell.userimage)
             //   cell.userimage.addSubview(cell.myShadowView)

    }
*/
