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

public protocol DPadDelegate {
    func directionDidChange(direction: DPad.Direction)
}

final public class DPad: SKNode {

    public var delegate: DPadDelegate?
    var movementVector: Vec2 = Vec2(x: 0.0, y: 0.0)
    var initialPosition: CGPoint?

    public enum Direction {
        case None
        case Left
        case Right
        case Up
        case Down
    }

    var supportedDirections: Set<Direction> = Set()

    var backgroundTexture: SKTexture? {
        didSet {
            let textureSize = backgroundTexture?.size() ?? CGSizeZero
            let backgroundDiameter = min(textureSize.width, textureSize.height)

            backGround?.texture = backgroundTexture
            backGround?.size = CGSizeMake(backgroundDiameter, backgroundDiameter)

            size = backGround?.size ?? CGSizeZero
        }
    }

    var size: CGSize = CGSizeZero

    var backGround: SKSpriteNode?
    private var dPad: SKSpriteNode?

    public class func new(backgroundTexture: SKTexture? = nil,
        supportedDirections: Set<Direction>) -> DPad {
            let dPad = DPad()

            let frameworkBundle = NSBundle(forClass: self)
            let defaultBackgroundImage = UIImage(named: "thumbDefault", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            dPad.backgroundTexture = backgroundTexture ?? SKTexture(image: defaultBackgroundImage!)
            dPad.supportedDirections = supportedDirections

            return dPad
    }

    override init() {
        super.init()

        userInteractionEnabled = true
        backGround = SKSpriteNode()
        dPad = SKSpriteNode()
        dPad?.zPosition += 0.01

        guard let backGround = backGround,
            dPad = dPad else {
                print("Failed to initialize child nodes")
                return
        }

        dPad.addChild(backGround)
        addChild(dPad)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)

        // Set direction
        guard let background = backGround else {
            print("Failed to set up background")
            return
        }

        let current = touches.first!.locationInNode(background)

        let vec = Vec2(x: current.x, y: current.y)

        let constrainedVec = constrainedVector(vec, supportedDirections: supportedDirections)

        dPad?.position.x += constrainedVec.point.x
        dPad?.position.y += constrainedVec.point.y

        // Only update direction if vector magnitude is sufficently large.
        if constrainedVec.magnitude > 1.5 {
            switch constrainedVec.direction(constrainedVec.angle) {
            case .None:
                print("None: \(constrainedVec.angle)")
                delegate?.directionDidChange(.None)
            case .Up:
                print("up: \(constrainedVec.angle)")
                delegate?.directionDidChange(.Up)
            case .Down:
                print("down: \(constrainedVec.angle)")
                delegate?.directionDidChange(.Down)
            case .Right:
                print("right: \(constrainedVec.angle)")
                delegate?.directionDidChange(.Right)
            case .Left:
                print("left: \(constrainedVec.angle)")
                delegate?.directionDidChange(.Left)
            }
        }

    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        delegate?.directionDidChange(.None)
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
