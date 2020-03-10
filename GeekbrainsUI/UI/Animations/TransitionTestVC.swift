//
//  TransitionTestVC.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 21/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class TransitionVC: UIViewController, UINavigationControllerDelegate {
    var transitionInteraction: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        let edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeRecognize(_:)))
        
        edgeRecognizer.edges = .left
        view.addGestureRecognizer(edgeRecognizer)
        
        navigationController?.delegate = self
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func edgeRecognize(_ gesture: UIScreenEdgePanGestureRecognizer){
        let translation = gesture.translation(in: gesture.view)
        let percentComplete = translation.x / gesture.view!.bounds.size.width
        
        switch gesture.state{
        case .began:
            self.hasStarted = true
            transitionInteraction = UIPercentDrivenInteractiveTransition()
        navigationController?.popViewController(animated: true)
        case .changed:
            self.shouldFinish = percentComplete > 0.33
            print(percentComplete)
            transitionInteraction?.update(percentComplete)
        case .ended:
            self.hasStarted = false
            let velocity = gesture.velocity(in: gesture.view)
            print(percentComplete)
            if velocity.x > 0 || percentComplete > 0.5 {
                transitionInteraction?.finish()
            }else {
                transitionInteraction?.cancel()
            }
            
         
        default:break
        }//switch
           transitionInteraction = nil
    }//func edgeRecognize
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
   //     return self.hasStarted ? transitionInteraction : nil
        return transitionInteraction
    }
}// class TransitionVC
