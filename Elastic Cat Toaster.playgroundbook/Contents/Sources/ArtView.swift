//
//  ArtView.swift
//  RandoTests
//
//  Created by Adrián on 3/24/18.
//  Copyright © 2018 ment. All rights reserved.
//

import SpriteKit

public class ArtView: SKView, UIGestureRecognizerDelegate {
  
  let transition = SKTransition.crossFade(withDuration: 0.3)
  var title: String
  var index = 0

  public var regenerate: ((Int) -> ArtScene)? = nil
  
  public init(title: String, frame: CGRect) {
    self.title = title
    super.init(frame: frame)
    self.commonInit()
  }
  
  public required init?(coder decoder: NSCoder) {
    self.title = "-"
    super.init(coder: decoder)
    self.commonInit()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if let regenerateFunction = self.regenerate {
      let newScene = regenerateFunction(self.index)
      self.presentScene(newScene)
    }
  }
  
  func commonInit() {
//    self.showsFPS = true
//    self.showsNodeCount = true
    self.transition.pausesOutgoingScene = true
    self.transition.pausesIncomingScene = true
    
    let nextGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleNext))
    nextGestureRecognizer.direction = .left
    
    let prevGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handlePrev))
    prevGestureRecognizer.direction = .right
    
//    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(regenerate))
//    prevGestureRecognizer.direction = .right
    
    self.addGestureRecognizer(nextGestureRecognizer)
    self.addGestureRecognizer(prevGestureRecognizer)

    self.generateAndPresent(withIndex: self.index)
  }
  
  @objc func replay() {
    self.index += 1
    self.generateAndPresent(withIndex: self.index)
  }
  

  @objc func handleNext() {
    self.index += 1
    self.generateAndPresent(withIndex: self.index)
  }

  @objc func handlePrev() {
    if self.index == 0 {
      return
    }
    self.index -= 1
    self.generateAndPresent(withIndex: self.index)
  }
  
  func generateAndPresent(withIndex index: Int) {
    if let regenerateFunction = self.regenerate {
      let newScene = regenerateFunction(index)
      self.presentScene(newScene, transition: transition)
    }
  }

  
  
}

