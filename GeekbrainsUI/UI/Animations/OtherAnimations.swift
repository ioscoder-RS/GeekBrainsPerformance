//
//  OtherAnimations.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
/*
@IBOutlet weak var animationShow: AnimationApple!

@IBOutlet weak var animationShow2: groupAnimation!

@IBAction func animationButtonPressed(_ sender: Any) {
    if animationShow.isHidden == true{
        animationShow.isHidden = false
   //     animationShow2.isHidden = false
       
        scrollView.drawRectStrokeGroupAnimation(object: Login2, strokeColor: UIColor.green.cgColor,flag: true) //animationShow2.drawRectStrokeGroupAnimation(object: Login2, strokeColor: UIColor.green.cgColor)
        
    } else{
        animationShow.isHidden = true
 //       animationShow2.isHidden = true
        
       scrollView.drawRectStrokeGroupAnimation(object: Login2, strokeColor: UIColor.green.cgColor,flag: false)
    }
}
*/


extension LoginViewController{
 
@objc func panRecognize(_ recognizer: UIPanGestureRecognizer){
    switch recognizer.state{
    case .began:
        propertyAnimator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 1.0, animations:{
            self.logo.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
        
    case .changed:
        let translation = recognizer.translation(in: self.view)
        propertyAnimator.fractionComplete = translation.y / 100
    case .ended:
        propertyAnimator.stopAnimation(true)
        propertyAnimator.addAnimations {
            self.logo.transform = .identity
        }
        propertyAnimator.startAnimation()
    default: break
    }
}
}// extension LoginViewController

