//
//  CustomNavigationControllerAnimation.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 22/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

//пример с видеолекции
class CustomNavigationControllerAnimation: UINavigationController, UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController)-> UIViewControllerAnimatedTransitioning?{
        switch operation{
        case .pop: return CustomPopAnimator()
        case .push: return CustomPushAnimator()
        case .none: return nil
        @unknown default: return nil
        }
    }//func

}// class CustomNavigationControllerAnimation


//пример с методички
class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
  
    let interactiveTransition = CustomInteractiveTransition()

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
                   self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC{ self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        
            }
        
        return nil
    }


}

