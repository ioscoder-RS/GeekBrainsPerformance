//
//  CommentButton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 16/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

class CustomCommentButton: UIButton{
   var Commented:Bool = false
   var commentCount: Int = 0

    func comment(){
       Commented = !Commented
        
    if Commented{
        setCommented()
    } else {
        disableComment()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault(userCommented: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault(userCommented: 0)
    }
    
    public func setCommentCount(commentCount:Int, userCommented:Int){
        self.commentCount = commentCount
        setupDefault(userCommented: userCommented)
    }
    
    private func setupDefault(userCommented: Int){
        setTitle(String(describing: commentCount), for: .normal)
        if userCommented == 1 {
            self.Commented = true
            tintColor = .red
        }else{
            self.Commented = false
            tintColor = .gray
        }
        
         titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)

    }
    
    private func setCommented(){
        commentCount += 1
        setTitle(String(describing: commentCount), for: .normal)
     //   animateComment(commented: Commented)
         tintColor = .red
    }
    
    private func disableComment(){
        commentCount -= 1
        setTitle(String(describing: commentCount), for: .normal)
    //    animateComment(commented: Commented)
         tintColor = .gray
    }
    
    func animateComment(commented: Bool){
      //  bounced-анимация увеличивает размер лайка при нажатии лайка и уменьшает при dislike
        var localScaleX: CGFloat = 1.0
        var localScaleY: CGFloat = 1.0
        
        if commented {
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


