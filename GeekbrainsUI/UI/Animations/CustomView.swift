//
//  CustomView.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 06/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//
import UIKit

 class CustomView: UIView{
    
    @IBInspectable var cornerRadius:CGFloat=20
    {
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        
//        guard let context = UIGraphicsGetCurrentContext() else{
//            return
//        }
        
        self.layer.cornerRadius = cornerRadius
    }
}

 class CustomUIImageView: UIImageView{
    @IBInspectable var cornerRadius:CGFloat=20
       {
           didSet{
               setNeedsDisplay()
           }
       }
    
    @IBInspectable var shadowColor:CGColor = UIColor.black.cgColor
    {
             didSet{
                 setNeedsDisplay()
             }
         }
    @IBInspectable var shadowOpacity: CGFloat = 1
    {
             didSet{
                 setNeedsDisplay()
             }
         }
    @IBInspectable var shadowRadius: Int = 10
    {
             didSet{
                 setNeedsDisplay()
             }
         }
    @IBInspectable var shadowOffset: CGSize = .zero
    {
             didSet{
                 setNeedsDisplay()
             }
         }
  
    
    override func draw(_ rect: CGRect) {
        super .draw(rect)
       
         self.layer.cornerRadius = cornerRadius
        self.backgroundColor = UIColor.link
    }
    
       
}
