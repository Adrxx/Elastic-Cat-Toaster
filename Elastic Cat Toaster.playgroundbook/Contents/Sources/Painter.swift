//
//  Painter.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/29/18.
//  Copyright © 2018 ment. All rights reserved.
//

import UIKit
import SpriteKit

/// The particle emmiter used for the sCanvas Scenes
public class Painter: SKEmitterNode {

  public convenience init(style: Style) {
    self.init(fileNamed: style.rawValue)!
    self.physicsBody = SKPhysicsBody(circleOfRadius: 2.5)
    self.physicsBody?.linearDamping = 0.0
    self.physicsBody?.friction = 0.0
    self.physicsBody?.restitution = 0.0
    self.physicsBody?.mass = 0.15
    self.physicsBody?.categoryBitMask = PhysicsCategory.painter
    self.physicsBody?.collisionBitMask = PhysicsCategory.none
    self.fieldBitMask = PhysicsCategory.painterParticleField
  }

  public enum Style: String {
    case cool
  }
  
}
