//
//  EmitterSnow.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 23/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

class EmitterSnow{
    //функция посыпает снегом
    func letItSnow(duration: Double, view: UIView){
        let emitterSnow = CAEmitterCell()
        emitterSnow.contents = UIImage(named:"snow")?.cgImage
        emitterSnow.scale = 0.01
        emitterSnow.scaleRange = 0.03
        emitterSnow.birthRate = 40
        emitterSnow.lifetime = 10
        emitterSnow.velocity = -30
        emitterSnow.velocityRange = -20
        emitterSnow.yAcceleration = 30
        emitterSnow.xAcceleration = 5
        emitterSnow.spin = -0.5
        emitterSnow.spinRange = 1.0
        
        let snowEmitterLayer = CAEmitterLayer()
        
        // центр анимации
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = .circle
        snowEmitterLayer.beginTime = CACurrentMediaTime() + 0.5
        //        snowEmitterLayer.timeOffset = 10
        snowEmitterLayer.duration = duration
        snowEmitterLayer.emitterCells = [emitterSnow]
        
        view.layer.addSublayer(snowEmitterLayer)
        
    }
}//class EmitterSnow
