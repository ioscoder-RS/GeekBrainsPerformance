//
//  groupAnimation.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 20/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class groupAnimation:UIView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }//draw
    
}//class groupAnimation:UIView

extension UIView{
    public func drawRectStrokeGroupAnimation(object:UIControl, strokeColor:CGColor, flag: Bool){
          let rectLayer = CAShapeLayer()
     
        rectLayer.path = UIBezierPath(rect: CGRect(x: object.frame.minX, y: object.frame.minY, width: object.frame.width, height: object.frame.height)).cgPath

            rectLayer.strokeColor = strokeColor
        //rectLayer.opacity = 0.5
        
                 rectLayer.lineWidth = 3
     
            
            
            let strokeAnimationStart = CABasicAnimation(keyPath: "strokeStart")
            strokeAnimationStart.fromValue = 0
            strokeAnimationStart.toValue = 1.0
            
            let strokeAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimationEnd.fromValue = 0
            strokeAnimationEnd.toValue = 1.2
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = 1.0
            groupAnimation.animations = [strokeAnimationStart, strokeAnimationEnd]
            groupAnimation.autoreverses = true
        groupAnimation.repeatCount = .infinity
            groupAnimation.isRemovedOnCompletion = true
        groupAnimation.fillMode = .removed
        
       if flag{ //запускаем анимацию
        //к основному слою вьюхи добавили слой анимации, CAShapelayer()
            layer.addSublayer(rectLayer)
        //в слой анимации добавили саму анимацию
            rectLayer.add(groupAnimation, forKey: "strokeGroup")
        //на слой анимации добавили сверху слой объекта, иначе был бы черный квадрат
         //   rectLayer.addSublayer(object.layer)
        }
        else{//останавливаем анимацию
 //           rectLayer.strokeColor = UIColor.clear.cgColor
        groupAnimation.animations = []
        groupAnimation.repeatCount = 0
        rectLayer.lineWidth = 0
        rectLayer.path = nil
        rectLayer.lineWidth = 0
        rectLayer.opacity = 0
        rectLayer.removeAllAnimations()

        
        rectLayer.removeFromSuperlayer()
        /*
        for layer in layer.sublayers!{
            if layer.name == "rectLayer" {
                layer.removeFromSuperlayer()
            }
        }//for
*/
     //    rectLayer.addSublayer(object.layer)
        } //else
        
       // object.layer.addSublayer(rectLayer)
    }
}

/*
    if let strokeEnd = rectLayer.presentation()?.strokeEnd{

        rectLayer.strokeEnd = strokeEnd

    }*/
