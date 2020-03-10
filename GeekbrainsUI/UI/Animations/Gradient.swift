//
//  Gradient.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 09/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class CustomGradient: UIView{
    var testView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  addImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
  //      addImage()
         testView = UIView(frame: frame)
            testView.frame = testView.bounds
        
         let gradientLayer = CAGradientLayer()
         gradientLayer.frame = testView.frame
         gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.link.cgColor]
   
         gradientLayer.locations = [0 as NSNumber, 1 as NSNumber]
        //направление градиента
         gradientLayer.startPoint = CGPoint(x: 0, y: 0)
         gradientLayer.endPoint = CGPoint(x: 0, y: 1) // от 0,0 до 0,1 означает строго вертикальный градиент
         layer.addSublayer(gradientLayer)
        
    }
    /*
    func addImage(){
         testView = UIView(frame: frame)
         addSubview(testView)
     }
    */
  /*  override func layoutSubviews() {

        

    }*/
}
