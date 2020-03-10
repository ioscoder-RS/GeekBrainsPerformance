//
//  TransitionAnimations.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else {return}
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        //двигаем второй экран направо с поворотом 90 градусов вверх
        let translation = CGAffineTransform(rotationAngle: -(CGFloat.pi/2))
        let shift = CGAffineTransform(translationX: source.view.frame.width, y: -source.view.frame.height/2)
        destination.view.transform = translation.concatenating(shift)
        
        
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    //первый экран уходит налево вверх
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        
                                                        let translation = CGAffineTransform(rotationAngle: (CGFloat.pi/2))
                                                        let shift = CGAffineTransform(translationX: -(source.view.frame.width)/4, y: -source.view.frame.height/2)
                                                        source.view.transform = translation.concatenating(shift)
                                                        
                                    })
                                    //второй экран появляется из правого верхнего угла
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: (CGFloat.pi/16))
                                                        let shift = CGAffineTransform(translationX: -(destination.view.frame.width)/16, y: 0)
                                                        destination.view.transform = translation.concatenating(shift)
                                    })
                                    
                                    
                                    //второй экран встает на окончательное место
                                    UIView.addKeyframe(withRelativeStartTime: 1.0,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }// func animateTransition
    
    
}//class CustomPushAnimator

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        //   transitionContext.containerView.sendSubviewToBack(destination.view)
        destination.view.frame = source.view.frame
        
        //двигаем новый экран влево-вверх
        let translation = CGAffineTransform(rotationAngle: (CGFloat.pi/2)) //90 градусов влево-вверх
        let shift = CGAffineTransform(translationX: -source.view.frame.width, y: -source.view.frame.height/2) //назад по Х и вверх  по Y
        destination.view.transform = translation.concatenating(shift)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    //исходный экран уходит направо-вверх
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: -(CGFloat.pi/2))
                                                        let shift = CGAffineTransform(translationX: destination.view.frame.width/4, y: -destination.view.frame.height/2)
                                                        source.view.transform = translation.concatenating(shift)
                                    })
                                    //новый экран появляется слева
                                    UIView.addKeyframe(withRelativeStartTime: 0.2,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        let translation = CGAffineTransform(rotationAngle: -(CGFloat.pi/4))
                                                        let shift = CGAffineTransform(translationX: destination.view.frame.width/4, y: 0)
                                                        destination.view.transform = translation.concatenating(shift)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
                                    
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
}//class CustomPopAnimator

///////////
///  закрываем экран жестом
/////


class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition{
    
    var viewController: UIViewController? {      didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                              action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }// var viewController
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.33
            
            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
    
}//class CustomInteractiveTransition


