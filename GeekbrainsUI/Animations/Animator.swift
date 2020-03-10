//
//  Animator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 01/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class ImagePresenter: NSObject, UIViewControllerTransitioningDelegate {
    let animator = Animator()
    
    var size = CGRect.zero
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    }

class Animator: NSObject, UIViewControllerAnimatedTransitioning{
    var frame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        let initialFrame = frame
        let finalFrame = fromView?.frame
        
        let xScale = initialFrame.width/finalFrame!.width
        let yScale = initialFrame.height/finalFrame!.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScale, y: yScale)
        
        toView?.transform = scaleTransform
        toView?.center = CGPoint(x: frame.midX, y: frame.midY)
        toView?.clipsToBounds = true
        
        container.addSubview(toView!)
        container.bringSubviewToFront(toView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.transform = .identity
            toView?.center = CGPoint(x: finalFrame!.midX, y: finalFrame!.midY)
        }){ complete in transitionContext.completeTransition(true)
            
        }
    }
}

