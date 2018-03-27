//
//  ArtScene.swift
//  RandoTests
//
//  Created by Adrián on 3/24/18.
//  Copyright © 2018 ment. All rights reserved.
//

import SpriteKit

public class ArtScene: SKScene {
  
  var finalFilter: CIFilter?
  
  public override func sceneDidLoad() {
    super.sceneDidLoad()
    self.scaleMode = .aspectFit
    self.finalFilter?.setDefaults()
  }
  
  public override func didMove(to view: SKView) {
    super.didMove(to: view)
  }

  public override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    if let finalFilter = self.finalFilter {
      self.filter = finalFilter
      self.shouldEnableEffects = true
    }
  }
  
}

