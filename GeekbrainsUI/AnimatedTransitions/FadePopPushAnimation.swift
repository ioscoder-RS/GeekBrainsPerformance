//
//  FadePopPushAnimation.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit


class FadePushAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else{return}
        
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {toVC.view.alpha = 1.0})
        {completion in transitionContext.completeTransition(completion)}
        
    }// func animateTransition
}//class FadePushAnimation

class FadePopAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else{return}
        
        transitionContext.containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {toVC.view.alpha = 0.0})
        {completion in transitionContext.completeTransition(completion)}
        
    }// func animateTransition
}//class FadePopAnimation


