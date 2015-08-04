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
	var wallWidth = 0 as Float
	var wallHeight = 0 as Float
	var boxWidth = 0 as Float
	var wallArray: [SKSpriteNode] = []
	var blockArray: [SKSpriteNode] = []
	var wallPositionEven = true
	var timeOfLastDrop: CFTimeInterval = 0.0
	var timePerMove: CFTimeInterval = 0.8
	var currentBlock: SKSpriteNode?
	var hit = false
	var scoreLabel: SKLabelNode = SKLabelNode(text: "0")
	var score = 0
	var lastRandomNumber: Float = 0.0
	var gravityIncrement: Float = 0.02
	
    override func didMoveToView(view: SKView) {
		
		self.size = UIScreen.mainScreen().bounds.size
		self.backgroundColor = UIColor.whiteColor()
		
		self.view?.showsFPS = false
		self.view?.showsNodeCount = false
		
		self.wallWidth = Float(self.size.width/7)
		self.boxWidth = wallWidth - 10
		self.wallHeight = Float(wallWidth*3/2)
		
		self.scaleMode = SKSceneScaleMode.AspectFit
		
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
		
		for var i = 0; i < 7; i += 2 {
			let wall = SKSpriteNode(imageNamed: "Fire")
			wall.size = CGSizeMake(CGFloat(wallWidth-5), CGFloat(wallHeight-5))
			let wallXPosition = Float(Float(i) * self.wallWidth) + wallWidth/2;
			wall.position = CGPointMake(CGFloat(wallXPosition), CGFloat(wallHeight/2 - 5))
			wall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(wallHeight/2))
			wall.physicsBody?.dynamic = false
			wall.physicsBody?.categoryBitMask = 0
			wall.physicsBody?.contactTestBitMask = 1
			wall.physicsBody?.collisionBitMask = 1
			self.addChild(wall)
			wallArray.append(wall)
			wallPositionEven = true
		}
		
		// add score 
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.fontSize = 20
		scoreLabel.zPosition = 4
		scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		scoreLabel.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/2 + 100)
		scoreLabel.fontColor = UIColor.darkGrayColor()
		self.addChild(scoreLabel)
		
    }
	
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
   
			
			if !hit {
				// Move wall
				for var i = 0; i < wallArray.count; i++ {
					let wall: SKSpriteNode = wallArray[i]
					var wallXPosition = Float(wall.position.x) + wallWidth
					if wallPositionEven {
						wallXPosition = Float(wall.position.x) - wallWidth
						wall.position = CGPointMake(CGFloat(wallXPosition), wall.position.y)
					}
					else {
						wall.position = CGPointMake(CGFloat(wallXPosition), wall.position.y)
					}
				}
				wallPositionEven = !wallPositionEven
			}
		}
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		if !hit {
			moveBlocks(currentTime)
			
			for var i = 0; i < wallArray.count; i++ {
				let wall: SKSpriteNode = wallArray[i]
				
				if CGRectIntersectsRect(currentBlock!.frame, wall.frame){
					println("hit")
					hit = true
					currentBlock!.physicsBody?.affectedByGravity = false
					currentBlock!.physicsBody?.velocity = CGVector(dx: 0, dy: -50)
					currentBlock!.color = UIColor.redColor()
					currentBlock!.colorBlendFactor = 0.5
					//currentBlock!.position = CGPointMake(currentBlock!.position.x, CGFloat(wallHeight/2 +  17 + Float(currentBlock!.size.height)))
					
					if blockArray.count > 1 {
						for var j = 1; j < blockArray.count; j++ {
							if let deadBlock = blockArray[j] as SKSpriteNode? {
								deadBlock.physicsBody?.affectedByGravity = false
								deadBlock.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
							}
						}
					}
				}
			}
			
			if currentBlock?.frame.origin.y <= 0 {
				self.incrementScore()
			}
		}
		
    }
	
	func moveBlocks(currentTime: CFTimeInterval) {
		if (currentTime - timeOfLastDrop < timePerMove) {
			return
		}
		
		else {
			
			let sprite = SKSpriteNode(imageNamed:"Bird")
			self.updateDropLocation()
			sprite.size = CGSizeMake(CGFloat(boxWidth), CGFloat(boxWidth))
			sprite.position = self.dropLocation
			sprite.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.boxWidth/2))
			sprite.physicsBody?.dynamic = true
			sprite.physicsBody?.affectedByGravity = true
			sprite.physicsBody?.categoryBitMask = 1
			sprite.physicsBody?.contactTestBitMask = 0
			sprite.physicsBody?.collisionBitMask = 0
			blockArray.append(sprite)
			self.addChild(sprite)
			
			if let firstBlock: SKNode = self.currentBlock {
			
			}
			else {
				currentBlock = sprite
			}
			
		}
		timeOfLastDrop = currentTime
	}
	
	func updateDropLocation() {
		
		let randomNumber = Float(arc4random_uniform(7))
		let dropXPosition = randomNumber * self.wallWidth
		self.dropLocation = CGPointMake(CGFloat(dropXPosition + wallWidth/2), CGFloat(self.size.height))
		if lastRandomNumber == randomNumber {
			self.updateDropLocation()
		}
		else {
			lastRandomNumber = randomNumber
		}
	}
	
	func incrementScore() {
		score++
		scoreLabel.text = "\(score)"
		self.updateCurrentBlock()
		timePerMove = max(timePerMove * 0.98, 0.5)
		var yGravity = self.physicsWorld.gravity.dy
		yGravity.advancedBy(CGFloat(-gravityIncrement))
		gravityIncrement = gravityIncrement / Float(score)
		self.physicsWorld.gravity = CGVector(dx: 0, dy: yGravity)
	}
	
	func updateCurrentBlock() {
		blockArray.removeAtIndex(0)
		currentBlock = blockArray[0]
	}
	
	
}
