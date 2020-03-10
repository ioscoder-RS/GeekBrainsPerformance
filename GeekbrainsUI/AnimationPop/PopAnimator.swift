//
//  PopAnimator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 26/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class PopAnimator:NSObject, UIViewControllerAnimatedTransitioning{
    let duration = 1.0
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeView = toView
        
        let finalFrame = recipeView.frame
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        recipeView.transform = scaleTransform
        recipeView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        
        recipeView.clipsToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        UIView.animate(withDuration: duration, animations:{
            recipeView.transform = .identity
            recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) {isComplete in transitionContext.completeTransition(isComplete)}
    }//func animateTransition
    
}//class PopAnimator:
