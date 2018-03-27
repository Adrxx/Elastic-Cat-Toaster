//
//  PresentationScene.swift
//  RandoTests
//
//  Created by Adrián on 3/24/18.
//  Copyright © 2018 ment. All rights reserved.
//

import SpriteKit

class PresentationScene: SKScene {
  
  convenience init(title: String) {
    self.init(fileNamed: "PresentationScene")!
    if let titleNode = self.childNode(withName: "title") as? SKLabelNode {
      titleNode.text = title
    }
  }
  
}

