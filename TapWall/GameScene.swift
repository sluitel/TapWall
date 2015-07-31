//
//  GameScene.swift
//  TapWall
//
//  Created by Subash Luitel on 7/23/15.
//  Copyright (c) 2015 Luitel Apps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var dropLocation = CGPointMake(CGFloat(0), CGFloat(0))
	var boxWidth = 0 as Float
	
    override func didMoveToView(view: SKView) {
		
		self.size = UIScreen.mainScreen().bounds.size
		self.backgroundColor = UIColor.whiteColor()
		
		
		self.boxWidth = Float(self.size.width/7)
		
		self.scaleMode = SKSceneScaleMode.AspectFit
		self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
		
    }
	
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
			let sprite = SKSpriteNode(imageNamed:"Block")
			self.updateDropLocation()
			sprite.size = CGSizeMake(CGFloat(boxWidth), CGFloat(boxWidth))
			
			sprite.position = self.dropLocation
			sprite.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.boxWidth/2))
			self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
	
	func updateDropLocation() {
		
		let dropXPosition = Float(arc4random_uniform(6)) * self.boxWidth
		self.dropLocation = CGPointMake(CGFloat(dropXPosition + boxWidth/2), CGFloat(self.size.height))
	}
	
	
}
