//
//  CanvasHelper.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

func toCanvasCoords(canvasSize : CGSize, point: CGPoint) -> CGPoint {
    let widthRatio = canvasSize.width / 7000
    let heightRatio = canvasSize.height / 3000
    
    return CGPoint(x: point.x * widthRatio, y: canvasSize.height - point.y * heightRatio)
}
