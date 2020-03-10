//
//  AnimationApple.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 18/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class AnimationApple: UIView {
    
    let firstBirdPath: UIBezierPath = {
     
        let freeform = UIBezierPath()
 //       freeform.move(to: CGPoint(x:110.89, y:99.2 ))
         freeform.move(to: CGPoint(x:50, y:50 ))
    freeform.addLine(to: CGPoint(x: 50, y: 150))
    freeform.addLine(to: CGPoint(x: 150, y: 50))
    freeform.addLine(to: CGPoint(x: 50, y: 50))
   // freeform.addLine(to: CGPoint(x:150, y:150))
     //   freeform.close()
        
        return freeform
} ()
    
        let secondBirdPath: UIBezierPath = {
         
            let freeform1 = UIBezierPath()
             freeform1.move(to: CGPoint(x:50, y:50 ))
        freeform1.addLine(to: CGPoint(x: 50, y: 150))
        freeform1.addLine(to: CGPoint(x: 260, y: 160))
        freeform1.addLine(to: CGPoint(x: 260, y: 60))
        freeform1.addLine(to: CGPoint(x:160, y:60))
        freeform1.addLine(to: CGPoint(x:50, y:50))
         //   freeform.close()
            
            return freeform1
    } ()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        /*
        let firstBirdLayer = CAShapeLayer()
       // firstBirdLayer.path = firstBirdPath.cgPath
        
        
        firstBirdLayer.strokeColor = UIColor.systemTeal.cgColor
        firstBirdLayer.backgroundColor = UIColor.systemTeal.cgColor
        firstBirdLayer.lineWidth = 3
        layer.addSublayer(firstBirdLayer)
 */
 /*
        let secondBirdLayer = CAShapeLayer()
       // secondBirdLayer.path = secondBirdPath.cgPath
   
        
        secondBirdLayer.strokeColor = UIColor.systemTeal.cgColor
        secondBirdLayer.backgroundColor = UIColor.systemTeal.cgColor
        secondBirdLayer.lineWidth = 3
        layer.addSublayer(secondBirdLayer)
   */
        let firstBirdAnimation = CAKeyframeAnimation(keyPath: "position")
        firstBirdAnimation.path = firstBirdPath.cgPath
        firstBirdAnimation.duration = 10.0
        firstBirdAnimation.rotationMode = .rotateAuto
        firstBirdAnimation.repeatCount = .infinity
        
        let firstBirdPictureLayer = CAShapeLayer()
        firstBirdPictureLayer.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
        firstBirdPictureLayer.contents = UIImage(named:"eagle")?.cgImage
        firstBirdPictureLayer.add(firstBirdAnimation, forKey: nil)
 
        let secondBirdAnimation = CAKeyframeAnimation(keyPath: "position")
        secondBirdAnimation.path = secondBirdPath.cgPath
        secondBirdAnimation.calculationMode = CAAnimationCalculationMode.paced
        secondBirdAnimation.duration = 10.0
        secondBirdAnimation.rotationMode = .rotateAuto
        secondBirdAnimation.repeatCount = .infinity
        
      
        let secondBirdPictureLayer = CAShapeLayer()
        let colibri = UIImage(named:"colibri")?.cgImage
        
        secondBirdPictureLayer.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        secondBirdPictureLayer.contents = colibri
   
      secondBirdPictureLayer.add(secondBirdAnimation,forKey: nil)
        
        
        /*
        let groupAnimation = CAAnimationGroup()
         groupAnimation.duration = 5.0
         groupAnimation.animations = [firstBirdAnimation, secondBirdAnimation]
   //      groupAnimation.autoreverses = true
         groupAnimation.repeatCount = .infinity
         groupAnimation.isRemovedOnCompletion = false
         groupAnimation.fillMode = .forwards
         */

        //layer.add(groupAnimation, forKey: nil)
     //   likeLayer.add(animationsGroup, forKey: nil)
        
        layer.addSublayer(firstBirdPictureLayer)
         layer.addSublayer(secondBirdPictureLayer)
    }
    

} //class AnimationApple: appleLogoPath.cgPath

/*
 
   let animationsGroup = CAAnimationGroup()
   animationsGroup.duration = 0.5
   animationsGroup.fillMode = CAMediaTimingFillMode.backwards
 
 let translation = CABasicAnimation(keyPath: "position.x")
 translation.toValue = 100
 
 
 let alpha = CABasicAnimation(keyPath: "opacity")
 translation.toValue = 0
 animationsGroup.animations = [translation, alpha]

 */
