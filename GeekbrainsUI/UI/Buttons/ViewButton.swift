//
//  ViewButton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 16/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class CustomViewButton: UIButton{
   var viewed:Bool = false
   var viewedCount: Int = 0

    func setLook(){
       viewed = !viewed
        
    if viewed{
        addLook()
    } else {
        disableLook()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault(userViewed: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault(userViewed: 0)
    }
    
    public func setViewedCount(viewedCount:Int, userViewed:Int){
        self.viewedCount = viewedCount
        setupDefault(userViewed: userViewed)
    }
    
    private func setupDefault(userViewed: Int){
        setTitle(String(describing: viewedCount), for: .normal)
        if userViewed == 1 {
            self.viewed = true
            tintColor = .red
        }else{
            self.viewed = false
            tintColor = .gray
        }
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
    }
    
    private func addLook(){
        viewedCount += 1
        setTitle(String(describing: viewedCount), for: .normal)
   //     animateLook(viewed: viewed)
         tintColor = .red
    }
    
    private func disableLook(){
        viewedCount -= 1
        setTitle(String(describing: viewedCount), for: .normal)
  //      animateLook(viewed: viewed)
         tintColor = .gray
    }
    
    func animateLook(viewed: Bool){
      //  bounced-анимация увеличивает размер лайка при нажатии лайка и уменьшает при dislike
        var localScaleX: CGFloat = 1.0
        var localScaleY: CGFloat = 1.0
        
        if viewed {
            localScaleX = 1.5
            localScaleY = 1.5
        } else{
  localScaleX = 0.75
   localScaleY = 0.75
        }
        
        UIView.animate(
                   withDuration: 0.5,
                   delay: 0,
                   options: [],
                   animations:{ self.transform = CGAffineTransform(scaleX: localScaleX, y: localScaleY)},
                   completion: {_ in UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)}
                       )
               })
    }// func animateComment
    
}//class CustomCommentButton



