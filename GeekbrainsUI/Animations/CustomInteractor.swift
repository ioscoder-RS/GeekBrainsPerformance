//
//  CustomInteractor.swift
//  CustomNavigationAnimations-Starter
//
//  Created by raskin-sa on 26/12/2019.
//  Copyright © 2019 Sam Stone. All rights reserved.
//

import UIKit

/*
 The idea of this class is to attach a UIScreenEdgePanGestureRecognizer (the swipe to go back gesture) to the destination ViewController that updates the custom transition based on the percent of the swipe the user has made on the ViewController.
 We’ll create 3 properties, one to store the NavigationController, one to reference whether we should complete a transition (if we’re more then half way through the swipe and the user lets go, we complete the transition, if not, we cancel the transition), and one to reference whether there is a transition in progress. We’ll initialise the class with a failable initialiser, that contains a parameter ViewController we want to attach to. */

class CustomInteractor : UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackGesture(view: viewController.view)
        } else {
            return nil
        }
    }
    
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / self.navigationController.view.frame.width
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
        finish()
        
    }//@objc private func handleBackGesture
    
    
}//class CustomInteractor


