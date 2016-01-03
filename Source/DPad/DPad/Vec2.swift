//
//  Vec2.swift
//  DPad
//
//  Created by Matthew Buckley on 12/25/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import Foundation

public struct Vec2 {

    var x: CGFloat = 0.0
    var y: CGFloat = 0.0

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    /// Computed point from vector.
    var point: CGPoint {
        return CGPoint(x:x, y:y)
    }

    /// Computed length of vector.
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }

    /// Computed magnitude of vector
    var magnitude: CGFloat {
        return hypot(x, y)
    }

    /**
     Scales vactor by factor.

     - parameter factor: factor by which to scale the vector.

     - returns: a Vec2 scaled by the factor passed in.
     */
    mutating func scale(byFactor factor: CGFloat) -> Vec2 {
        x = x * factor
        y = y * factor
        return self
    }

    /// Computed angle of vector relative to x axis.
    var angle: CGFloat {
        return atan2(self.y, self.x)
    }

    /**
     Calculates cross product of 2 vectors.

     - parameter vector1: a Vec2 instance.
     - parameter vector2: a Vec2 instance.

     - returns: a CGFloat representing the cross product of the 2 vectors.
     */
    func crossProduct(vector1: Vec2, vector2: Vec2) -> CGFloat {
        return (vector1.x * vector2.y - vector1.y * vector2.x)
    }

    /**
     Calculates dot product of 2 vectors.

     - parameter vector1: a Vec2 instance.
     - parameter vector2: a Vec2 instance.

     - returns: a CGFloat representing the dot product of the 2 vectors.
     */
    func dotProduct(vector1: Vec2, vector2: Vec2) -> CGFloat {
        return vector1.x * vector2.x + vector1.y * vector2.y
    }

}

extension Vec2 {

    func direction(vectorAngle: CGFloat) -> DPad.Direction {
        var direction = DPad.Direction.None
        switch vectorAngle {
            case let a where fabs(a) < CGFloat(M_PI_4):
                direction = .Right
            case let a where a > CGFloat(M_PI_4) && a <= CGFloat(3 * M_PI_4):
                direction = .Up
            case let a where (a > 0.0 && a > CGFloat(3 * M_PI_4)) || (a < 0.0 && fabs(a) > CGFloat(3 * M_PI_4)):
                direction = .Left
            case let a where a < 0.0 && fabs(a) >= CGFloat(M_PI_4) && fabs(a) <= CGFloat(3 * M_PI_4):
                direction = .Down
            default:
                break
        }
        return direction
    }

}

extension Vec2: StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) {
        let point = CGPointFromString(value)
        self = Vec2(x: point.x, y: point.y)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        let point = CGPointFromString(value)
        self = Vec2(x: point.x, y: point.y)
    }

    public init(unicodeScalarLiteral value: StringLiteralType) {
        let point = CGPointFromString(value)
        self = Vec2(x: point.x, y: point.y)
    }
}

extension Vec2: Equatable {}

public func == (lhs: Vec2, rhs: Vec2) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
