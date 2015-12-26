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

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Soap Quest"
        myLabel.fontSize = 25
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)

            if dPad == nil {
                dPad = DPad.new(nil, supportedDirections: [.Up,
                                                                            .Down,
                                                                            .Left,
                                                                            .Right])

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
}

extension GameScene: DPadDelegate {
    func directionDidChange(direction: DPad.Direction) {
        print(direction)
    }

    func touchesEnded(forDpad dPad: DPad) {
        //
    }
}
