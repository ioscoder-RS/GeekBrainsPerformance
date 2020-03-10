//
//  ShareButton.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 16/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit
class CustomShareButton: UIButton{
   var shared:Bool = false
    var shareCount: Int = 0

    func share(){
       shared = !shared
        
    if shared{
        setShared()
    } else {
        disableShare()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault(userShared: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault(userShared: 0)
    }
    
    public func setShareCount(shareCount:Int, userShared:Int){
        self.shareCount = shareCount
        setupDefault(userShared: userShared)
    }
    
    private func setupDefault(userShared: Int){
        setTitle(String(describing: shareCount), for: .normal)
        
        if userShared == 1 {
             self.shared = true
             tintColor = .red
         }else{
             self.shared = false
             tintColor = .gray
         }
         
         titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
    }
    
    private func setShared(){
        shareCount += 1
        setTitle(String(describing: shareCount), for: .normal)
        
    //    animateShare(shared: shared)
         tintColor = .red
   
    }
    
    private func disableShare(){
        shareCount -= 1
        setTitle(String(describing: shareCount), for: .normal)
        
    //    animateShare(shared: shared)
         tintColor = .gray
    }
    
    func animateShare(shared: Bool){
      //  bounced-анимация увеличивает размер лайка при нажатии лайка и уменьшает при dislike
        var localScaleX: CGFloat = 1.0
        var localScaleY: CGFloat = 1.0
        
        if shared {
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
    }// func animateShare
    
}//class ShareButton

