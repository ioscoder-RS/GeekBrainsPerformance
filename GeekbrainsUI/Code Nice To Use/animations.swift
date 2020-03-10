//
//  Анимации.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 15/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import Foundation

    func testAnimation() {
        //для constraint' ов
        // self.view.layoutIfNeeded()
  /*
         UIView.animate( withDuration: 2.0,
                        delay: 2.0,
                        options: [.repeat, .autoreverse],
                        animations:{ //self.groupSearchBar.frame.origin.y -= 300
                            
                            //self.spaceConstraint.constant = 50
                            //для constraint' ов
                               // self.view.layoutIfNeeded()
        })
  */
        /*
         //Анимация на слое. Изменяет св-во во времени
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = groupSearchBar.layer.position.y
        animation.toValue = groupSearchBar.layer.position.y + 100
        animation.duration = 2
        groupSearchBar.layer.add(animation, forKey: "changePosition")
        */
        
        /*
         //Анимация на слое, изменяет свойство во времени с разной скоростью по частям
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [groupSearchBar.layer.position.y,
                            groupSearchBar.layer.position.y + 100,
            groupSearchBar.layer.position.y + 200,
            groupSearchBar.layer.position.y + 300]
            
            
        animation.keyTimes = [0, 0.4, 0.5, 1.0]
        animation.duration = 5
         //чтобы отследить конец анимации
        animation.fillMode = .forwards
         animation.isRemovedOnCompletion = false
         
        groupSearchBar.layer.add(animation, forKey: "changePosition")
 */
 /*
       // bounced animation
        UIView.animate(withDuration: 2.0, delay: 1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0,
                       options: [], animations: {self.groupSearchBar.frame.origin.y += 100})
  */
  
        /*
         //код анимации на слое с перемещением Layer'а по итогам анимации
        CATransaction.begin()
        
  //      print(groupSearchBar.frame)
        CATransaction.setCompletionBlock{
     //       print("до присвоения в CATransaction.setCompletionBlock")
   //         print(self.groupSearchBar.frame)
            
            //!!!!! необходимо присвоить слою новые координаты
            self.groupSearchBar.frame = CGRect(x:self.groupSearchBar.frame.minX,
                                               y:self.groupSearchBar.layer.position.y + 300,
                                               width: self.groupSearchBar.frame.width,
                                               height: self.groupSearchBar.frame.height)
   //         print("после присвоения в CATransaction.setCompletionBlock")
   //         print(self.groupSearchBar.frame)
        }
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [groupSearchBar.layer.position.y,
                            groupSearchBar.layer.position.y + 100,
            groupSearchBar.layer.position.y + 200,
            groupSearchBar.layer.position.y + 300]
            
            
        animation.keyTimes = [0, 0.4, 0.5, 1.0]
        animation.duration = 5
         //чтобы отследить конец анимации
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        groupSearchBar.layer.add(animation, forKey: "changePosition")
        CATransaction.commit()
    */
        
/*
   //      emitter animation = снежинки
         
        let emitterSnow = CAEmitterCell()
        emitterSnow.contents = UIImage(named:"snow")?.cgImage
        emitterSnow.scale = 0.01
        emitterSnow.scaleRange = 0.05
        emitterSnow.birthRate = 40
        emitterSnow.lifetime = 10
        emitterSnow.velocity = -30
        emitterSnow.velocityRange = -20
        emitterSnow.yAcceleration = 30
        emitterSnow.xAcceleration = 5
        emitterSnow.spin = -0.5
        emitterSnow.spinRange = 1.0
        
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = .line
        snowEmitterLayer.beginTime = CACurrentMediaTime() + 2
        snowEmitterLayer.timeOffset = 10
        snowEmitterLayer.emitterCells = [emitterSnow]
        view.layer.addSublayer(snowEmitterLayer)
    */
        /*
    //анимация для лайка (увеличить размер/вернуть)
        UIView.animate(
            withDuration: 0.5,
            delay: 3,
            options: [],
            animations:{ self.groupSearchBar.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)},
            completion: {_ in UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {self.groupSearchBar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    })
 */
        /*
         код позволяет таблице выезжать с разворотом
         
         override func tableView(_ tableView: UITableView, willDisplay cell:
             UITableViewCell, forRowAt indexPath: IndexPath) {
             let rotationAngleInRadians = 360.0 * CGFloat(.pi/360.0)
           //  let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, -500, 100, 0)
             let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
             cell.layer.transform = rotationTransform
             UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
         }
         */
    }
