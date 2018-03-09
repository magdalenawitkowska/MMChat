//
//  TailView.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 09.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import Foundation
import UIKit

class TailView: UIView {
    
    var color: UIColor!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let raspberryRed = UIColor.init(red: 250/255, green: 64/255, blue: 107/255, alpha: 1.0)
        
        let fillColor = color == nil ? raspberryRed : color
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 19.7, y: -0))
        bezierPath.addLine(to: CGPoint(x: 0, y: -0))
        bezierPath.addCurve(to: CGPoint(x: 30, y: 14), controlPoint1: CGPoint(x: 5.52, y: 9.64), controlPoint2: CGPoint(x: 30.43, y: 14.58))
        bezierPath.addCurve(to: CGPoint(x: 19.7, y: -0), controlPoint1: CGPoint(x: 26, y: 11), controlPoint2: CGPoint(x: 20.65, y: 6.75))
        bezierPath.close()
        fillColor!.setFill()
        bezierPath.fill()
    }
}
