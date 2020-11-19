//
//  SideViewController-Speed.swift
//  PhotoGallery
//
//  Created by Shangen Zhang on 2019/9/26.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import Foundation

/// speed
extension SideViewController {
    enum SpeedDirection {
        case vertical
        case horizontal
    }
    
    struct PanSpeed {
        private var lastTime: CFAbsoluteTime
        private(set) var lastPoint: CGPoint
        private(set) var speed: CGFloat = 0
        private let speedDirection: SpeedDirection
        
        init(start point: CGPoint, direction: SpeedDirection = .horizontal) {
            lastTime = CFAbsoluteTimeGetCurrent()
            lastPoint = point
            speedDirection = direction
        }
        
        mutating func panDidChange(point: CGPoint) -> CGFloat {
            let currentTime = CFAbsoluteTimeGetCurrent()
            if point.equalTo(lastPoint) {
                lastPoint = point
                lastTime = currentTime
                return 0
            }
            let offset = (speedDirection == .vertical) ? (point.y - lastPoint.y) : (point.x - lastPoint.x)
            speed = offset / CGFloat(currentTime - lastTime)
            lastPoint = point
            lastTime = currentTime
            return offset
        }
    }
}
