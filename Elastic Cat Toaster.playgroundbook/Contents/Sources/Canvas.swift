//
//  Canvas.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/17/18.
//  Copyright © 2018 ment. All rights reserved.
//

import SpriteKit

/// Cool little experiment for the thank you screen
public class Canvas: ArtScene {
  
  public let randomMagnitude: Float = 1.2

  override public func sceneDidLoad() {
    super.sceneDidLoad()
    self.physicsWorld.gravity = CGVector.zero
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
    sceneBound.categoryBitMask = PhysicsCategory.walls
    sceneBound.friction = 0
    sceneBound.restitution = 1
    self.physicsBody = sceneBound
  }
  
  override func drawScene() {
    super.drawScene()
    self.backgroundColor = .black
    let separationFromCenter:CGFloat = 100
    // painters
    let painter = Painter(style: .cool)
    painter.physicsBody?.fieldBitMask = PhysicsCategory.commonFields | PhysicsCategory.painterField
    painter.targetNode = self
    painter.physicsBody?.velocity.dy = 200
    painter.physicsBody?.velocity.dx = -200

    painter.position.y = separationFromCenter
    
    let oppositePainter = Painter(style: .cool)
    oppositePainter.physicsBody?.fieldBitMask = PhysicsCategory.commonFields | PhysicsCategory.oppositePainterField
    oppositePainter.targetNode = self
    oppositePainter.position = painter.position.reflected
    oppositePainter.physicsBody?.velocity = painter.physicsBody!.velocity.reflected
    
    // Add them to the scene
    self.addChild(painter)
    self.addChild(oppositePainter)
    
    // The normal field
    let normalRandom = Random(seed: "WWDC 2018")
    let customField = SKFieldNode.customField {
      (position: vector_float3, velocity: vector_float3, mass: Float, charge: Float, deltaTime: TimeInterval) in
      let x = normalRandom.nextUniform() * self.randomMagnitude
      let y = normalRandom.nextUniform() * self.randomMagnitude
      return vector_float3(x,y,0)
    }
    customField.categoryBitMask = PhysicsCategory.painterField
    self.addChild(customField)
    
    // The opposite field
    let oppositeRandom = Random(seed: "WWDC 2018")
    let oppositeCustomField = SKFieldNode.customField {
      (position: vector_float3, velocity: vector_float3, mass: Float, charge: Float, deltaTime: TimeInterval) in
      let x = -oppositeRandom.nextUniform() * self.randomMagnitude
      let y = -oppositeRandom.nextUniform() * self.randomMagnitude
      return vector_float3(x,y,0)
    }
    oppositeCustomField.categoryBitMask = PhysicsCategory.oppositePainterField
    self.addChild(oppositeCustomField)

    // This are to keep everything close to the center
    let gravity = SKFieldNode.radialGravityField()
    gravity.strength = -2
    gravity.falloff = 2
    gravity.categoryBitMask = PhysicsCategory.commonFields
    self.addChild(gravity)
    
    let spring = SKFieldNode.springField()
    spring.strength = 1
    spring.falloff = -1
    let particleField = spring
    particleField.categoryBitMask = PhysicsCategory.commonFields
    self.addChild(particleField)
    
  }
  
}
