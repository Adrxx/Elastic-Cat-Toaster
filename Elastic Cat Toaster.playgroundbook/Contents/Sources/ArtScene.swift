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
  
  let random: Random
  
  public init(seed: String, dropValues: Int, size: CGSize) {
    self.random = Random(seed: seed)
    if dropValues > 0 {
      self.random.dropValues(count: dropValues)
    }
    super.init(size: size)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sceneDidLoad() {
    super.sceneDidLoad()
    self.scaleMode = .aspectFit
    self.finalFilter?.setDefaults()
  }
  
  public override func didMove(to view: SKView) {
    super.didMove(to: view)
    self.drawScene()
  }
  
  func drawScene() {}

  public override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    if let finalFilter = self.finalFilter {
      self.filter = finalFilter
      self.shouldEnableEffects = true
    }
  }
  
}

