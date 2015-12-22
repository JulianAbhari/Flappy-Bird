//
//  GameScene.swift
//  FlappyBird
//
//  Created by Julian Abhari on 8/16/15.
//  Copyright (c) 2015 Julian Abhari. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var pipeTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    
    let pipeGap = 150.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = UIColor(red: 2.0/255, green: 165.0/255, blue: 255.0/255, alpha: 1.0)
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        
        //add physics world
        physicsWorld.contactDelegate = self
        
        //Bird
        let BirdTexture = SKTexture(imageNamed: "Bird")
        BirdTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        bird = SKSpriteNode(texture: BirdTexture)
        bird.setScale(1.5)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6 )
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2.0)
        bird.physicsBody!.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        self.addChild(bird)
        
        //Ground
        let GroundTexture = SKTexture(imageNamed: "Ground")
        
        let sprite = SKSpriteNode(texture: GroundTexture)
        sprite.setScale(3.5)
        sprite.position = CGPointMake(self.size.width/2, self.size.height/8.0)
        
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, GroundTexture.size().height))
        
        sprite.physicsBody!.dynamic = false
        
        self.addChild(sprite)
        
        let ground = SKNode()
        
        ground.position = CGPointMake(1, GroundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, GroundTexture.size().height * 5))
        ground.physicsBody!.dynamic = false
        
        //Pipes
        pipeTexture = SKTexture(imageNamed: "pipe")
        
        //Movement of Pipes
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        PipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Spawn Pipes
        
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn,delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    func spawnPipes() {
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeTexture)
        pipeDown.setScale(4.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody!.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTexture)
        pipeUp.setScale(4.0)
        pipeUp.position = CGPointMake(0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody!.dynamic = false
        
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(PipesMoveAndRemove)
        self.addChild(pipePair)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            _ = touch.locationInNode(self)
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            
            bird.physicsBody?.applyImpulse(CGVectorMake(0,50))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
