# DPad
A reusable D-Pad framework for use in conjunction with [SpriteKit](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html).  


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/mattthousand/dpad)


<p align="center" >
<br/>
<img src="https://raw.github.com/nicethings/dpad/master/dpad.gif" alt="Overview" />
<br/>
</p>

## Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following commands:

```sh
brew update
brew install carthage
```

To integrate Shift into your Xcode project using Carthage, specify it in your Cartfile:

`github "mattThousand/DPad"`

## Installation with CocoaPods

... Coming soon.

## Usage

In your `SKScene` instance, import the DPad module: `import DPad`.

Initialize your	`DPad` using the `new` constructor, optionally setting its position. A recommended pattern is to initialize your `DPad` in `touchesBegan`:

```
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
   /* Called when a touch begins */
    
    for touch in touches {
        let location = touch.locationInNode(self)

        if dPad == nil {
            dPad = DPad.new(supportedDirections: [.Up, .Down, .Left, .Right])

            guard let dPad = dPad else {
                print("Failed to create D-Pad")
                return
            }
            self.addChild(dPad)
        }

        dPad?.position = location
    }
}
``` 

Then, to keep track of the DPad's position, override your `SKScene`'s `update` function and switch on the current `Direction` of your `DPad`:

```
override func update(currentTime: CFTimeInterval) {
    super.update(currentTime)
    motion?.invalidate()
    motion = nil
    let direction = dPad?.direction ?? DPad.Direction.None
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
```
