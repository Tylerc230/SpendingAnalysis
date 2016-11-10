//
//  UIView+Drawing.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//

import UIKit
enum HairlinePosition {
    case top, bottom, left, right
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
    
    func setStrokeColor(_ color: UIColor) {
        shapeLayer.strokeColor = color.cgColor
    }
    
    func addHairline(_ position: HairlinePosition) {
        let start: CGPoint
        let end: CGPoint
        switch position {
        case .top:
            start = CGPoint(x: 0.0, y: 0.0)
            end = start.offsetting(x: shapeLayer.frame.size.width)
            
        default:
            start = CGPoint.zero
            end = CGPoint.zero
        }
        let bezier: UIBezierPath
        if let path = shapeLayer.path {
            bezier = UIBezierPath(cgPath: path)
        } else {
            bezier = UIBezierPath()
        }
        
        bezier.move(to: start)
        bezier.addLine(to: end)
        shapeLayer.path = bezier.cgPath
    }
}

extension CGPoint {
    func offsetting(x: CGFloat = 0.0, y: CGFloat = 0.0) -> CGPoint {
        var new = self
        new.x += x
        new.y += y
        return new
    }
}
