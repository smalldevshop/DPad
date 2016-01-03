//
//  DPad.swift
//  DPad
//
//  Created by Matthew Buckley on 12/25/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

final public class DPad: SKNode {

    public var direction: DPad.Direction = DPad.Direction.None

    public enum Direction: Vec2 {
        case None = "{0, 0}"
        case Left = "{-1, 0}"
        case Right = "{1, 0}"
        case Up = "{0, 1}"
        case Down = "{0, -1}"
    }

    var supportedDirections: Set<Direction> = Set()

    var backgroundTexture: SKTexture? {
        didSet {
            let textureSize = backgroundTexture?.size() ?? CGSizeZero
            let backgroundDiameter = min(textureSize.width, textureSize.height)

            background?.texture = backgroundTexture
            background?.size = CGSize(width: backgroundDiameter, height: backgroundDiameter)

            size = background?.size ?? CGSizeZero
        }
    }

    private var background: SKSpriteNode?
    private var dPad: SKSpriteNode?
    private var size: CGSize = CGSizeZero

    public class func new(backgroundTexture: SKTexture? = nil,
        supportedDirections: Set<Direction>) -> DPad {
            let dPad = DPad()

            let frameworkBundle = NSBundle(forClass: self)
            let defaultbackgroundImage = UIImage(named: "thumbDefault", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            dPad.backgroundTexture = backgroundTexture ?? SKTexture(image: defaultbackgroundImage!)
            dPad.supportedDirections = supportedDirections

            return dPad
    }

    override init() {
        super.init()

        userInteractionEnabled = true
        background = SKSpriteNode()
        dPad = SKSpriteNode()
        dPad?.zPosition += 0.01

        guard let background = background,
            dPad = dPad else {
                print("Failed to initialize child nodes")
                return
        }

        dPad.addChild(background)
        addChild(dPad)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)

        // Set direction
        guard let background = background else {
            print("Failed to set up background")
            return
        }

        /// Create vector from current touch
        let current = touches.first!.locationInNode(background)
        let vec = Vec2(x: current.x, y: current.y)

        /// Create a new vector constrained according to the directions supported by the DPad instance
        let constrainedVec = constrainedVector(vec, supportedDirections: supportedDirections)

        dPad?.position.x += constrainedVec.point.x
        dPad?.position.y += constrainedVec.point.y

        // Only update direction if vector magnitude is greater than pi/2
        if constrainedVec.magnitude > CGFloat(M_PI_2) {
            switch constrainedVec.direction(constrainedVec.angle) {
            case .None:
                direction = .None
            case .Up:
                direction = .Up
            case .Down:
                direction = .Down
            case .Right:
                direction = .Right
            case .Left:
                direction = .Left
            }
        }

    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)

        // Update direction
        direction = .None
    }

    override public var position: CGPoint {
        didSet {
            // Recenter DPad when position of parent node is set.
            dPad?.position = CGPointZero
        }
    }
}

private extension DPad {

    /**
     Contrains vector based on DPad's supported directions (horizontal, vertical, all).

     - parameter vector:              a Vec2 instance.
     - parameter supportedDirections: a set of Directions.

     - returns: a Vec2 instance.
     */
    func constrainedVector(vector: Vec2, supportedDirections: Set<Direction>) -> Vec2 {
        var vec = Vec2(x: 0.0, y: 0.0)
        switch supportedDirections.intersect([.Up, .Down, .Left, .Right]) {
            case [.Up, .Down]:
                vec.y = vector.y
            case [.Left, .Right]:
                vec.x = vector.x
            case [.Up, .Down, .Left, .Right]:
                vec = vector
            default:
                break
        }
        return vec
    }
}
