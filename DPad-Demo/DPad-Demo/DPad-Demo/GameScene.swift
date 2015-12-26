//
//  GameScene.swift
//  DPad-Demo
//
//  Created by Matthew Buckley on 12/25/15.
//  Copyright (c) 2015 Matt Buckley. All rights reserved.
//

import SpriteKit
import DPad

class GameScene: SKScene {

    var dPad: DPad?
    var character: SKNode?
    var motion: NSTimer?

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        let texture = SKTexture(image: UIImage(named: "link")!)
        character = SKSpriteNode(texture: texture)
        character?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

        self.addChild(character!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)

            if dPad == nil {
                dPad = DPad.new(nil, supportedDirections: [.Up, .Down, .Left, .Right])

                dPad?.delegate = self
                dPad?.xScale = 0.5
                dPad?.yScale = 0.5

                guard let dPad = dPad else {
                    print("Failed to create D-Pad")
                    return
                }
                self.addChild(dPad)
            }

            dPad?.position = location
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func moveUp() {
        character?.position = CGPointMake(character!.position.x, character!.position.y + 1)
    }

    func moveDown() {
        character?.position = CGPointMake(character!.position.x, character!.position.y - 1)
    }

    func moveLeft() {
        character?.position = CGPointMake(character!.position.x - 1, character!.position.y)
    }

    func moveRight() {
        character?.position = CGPointMake(character!.position.x + 1, character!.position.y)
    }
}

extension GameScene: DPadDelegate {
    func directionDidChange(direction: DPad.Direction) {
        motion?.invalidate()
        motion = nil
        switch direction {
            case .None:
                break
            case .Up:
                motion = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "moveUp", userInfo: nil, repeats: true)
            case .Down:
                motion = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "moveDown", userInfo: nil, repeats: true)
            case .Left:
                motion = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "moveLeft", userInfo: nil, repeats: true)
            case .Right:
                motion = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "moveRight", userInfo: nil, repeats: true)
            }
    }
}
