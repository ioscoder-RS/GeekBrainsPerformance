//
//  ImageViewerPresenter.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 26/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

protocol ImageViewPresenterSource {
    var source: UIView? {get}
}

class ImageViewPresenter: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var animatorSource: ImageViewPresenterSource?
    var animator = PopAnimator()
    
    init(delegate: ImageViewPresenterSource){
        animatorSource = delegate
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC:UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let sourceView = animatorSource?.source,
            let origin = sourceView.superview?.convert(sourceView.frame,to: UIApplication.topViewController()!.navigationController!.view) else{
                return nil
        }
        animator.originFrame = CGRect(x: origin.minX,
                                      y: origin.minY,
                                      width: origin.size.width,
                                      height: origin.size.height)
        return animator
    }//    func navigationController(_ navigationController: UINavigationController,
}//class ImageViewPresenter
