//
//  UIView+Drawing.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
enum HairlinePosition {
    case Top, Bottom, Left, Right
}

protocol DrawableView  {
    var shapeLayer: CAShapeLayer! { get }
}

extension DrawableView where Self: UIView {
    func addShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = layer.bounds
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    func setStrokeColor(color: UIColor) {
        shapeLayer.strokeColor = color.CGColor
    }
    
    func addHairline(position: HairlinePosition) {
        let start: CGPoint
        let end: CGPoint
        switch position {
        case .Top:
            start = CGPoint(x: 0.0, y: 0.0)
            end = start.offsetting(x: shapeLayer.frame.size.width)
            
        default:
            start = CGPoint.zero
            end = CGPoint.zero
        }
        let bezier: UIBezierPath
        if let path = shapeLayer.path {
            bezier = UIBezierPath(CGPath: path)
        } else {
            bezier = UIBezierPath()
        }
        
        bezier.moveToPoint(start)
        bezier.addLineToPoint(end)
        shapeLayer.path = bezier.CGPath
    }
}

extension CGPoint {
    func offsetting(x x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGPoint {
        var new = self
        new.x += x
        new.y += y
        return new
    }
}
