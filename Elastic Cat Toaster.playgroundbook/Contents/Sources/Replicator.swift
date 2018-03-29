//
//  Replicator.swift
//  RandoTests
//
//  Created by Adrián on 3/21/18.
//  Copyright © 2018 ment. All rights reserved.
//

//
import SpriteKit

public class Replicator: ArtScene {
  
  public let maxBranches = 12
  public let minBranches = 2
  
  public let baseCellSize: CGFloat = 60.0
  public let maxCumulativeScaleRange: CGFloat = 0.16
  public let maxCumulativeRotationRange: CGFloat = 0.08
  public let maxCumulativeAlphaDifference: CGFloat = 0.08

  public var patternPeriod: UInt?
  public var cellImage: UIImage?
  public var cellColor: UIColor?
  public var cellScale: CGFloat?

  public var canvasColor: UIColor?
  public var allowRandomScale: Bool?
  public var randomScaleFactor: CGFloat = 1.7
  public var allowRandomSeparation: Bool?
  public var allowRandomRotation: Bool?
  public var revealAnimationDuration: TimeInterval = 0.4


  public let maxGenerations = 80
  
  public let separationAngle = CGFloat.pi/2
  
  public var replicationSchemas: [ReplicationSchema] = []
  
  let colorPalettes =  [
    Colors.anguila,
    Colors.summer,
    Colors.sector,
    Colors.insect,
    Colors.basic,
    Colors.midnight,
    Colors.sun,
    Colors.moonlight,
    Colors.fatal,
    Colors.sunset,
    Colors.organic,
    Colors.impressionist,
    Colors.abercrombie,
    Colors.aperture,
    Colors.eighties,
    Colors.emoGirl,
    Colors.native,
    Colors.zombie,
    Colors.violet,
    Colors.prism,
    Colors.insta,
    Colors.olde,
    Colors.ocean,
    ]
  let possibleTextures = [#imageLiteral(resourceName: "App"),#imageLiteral(resourceName: "Square"),#imageLiteral(resourceName: "Circle"),#imageLiteral(resourceName: "Hexagon"),#imageLiteral(resourceName: "Skewed"),#imageLiteral(resourceName: "Half-Triangle"),#imageLiteral(resourceName: "Boom"),#imageLiteral(resourceName: "Triangle")]
  
  override func drawScene() {
    super.drawScene()
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    let size = CGSize(width: self.baseCellSize, height: self.baseCellSize)
    
    let randomTexture = random.choiceFrom(possibleTextures)!
    let texture = SKTexture(image: self.cellImage ?? randomTexture)
    
    let randomColorPalette = random.choiceFrom(self.colorPalettes)!
    
    let randomCanvasColor = random.choiceFrom(randomColorPalette)!
    self.backgroundColor = self.canvasColor ?? randomCanvasColor
    
    let randomCumulativeScale = (CGFloat(random.nextUniform()) * self.maxCumulativeScaleRange) - self.maxCumulativeScaleRange/2.0
    
    let randomCumulativeRotation = (CGFloat(random.nextUniform()) * self.maxCumulativeRotationRange) - self.maxCumulativeRotationRange/2.0

    let allowRandomScale = (random.nextInt(lowerBound: 0, upperBound: 10) > 5)
    let allowRandomSeparation = (random.nextInt(lowerBound: 0, upperBound: 10) > 9)
    let allowRandomRotation = (random.nextInt(lowerBound: 0, upperBound: 10) > 8)
    
    let randomSpawnAnimation: SpawnAnimation = random.choiceFrom([.fadeIn,.moveIn,.growIn])!

    let repSchemaLeft = ReplicationSchema { (parameters) -> SKNode in
      let patternRandom = parameters.schemaRandom
      let wrapper = SKNode()
      let cell = SKSpriteNode(texture: texture, size: size)
      
      let randomColor = patternRandom.choiceFrom(randomColorPalette)!
      cell.color = self.cellColor ?? randomColor
      cell.colorBlendFactor = 1.0
      
      var randomScale = CGFloat(patternRandom.nextUniform()) * self.randomScaleFactor
      if !(self.allowRandomScale ?? allowRandomScale) {
        randomScale = 1.0
      }
      let scale = self.cellScale ?? randomScale
      cell.xScale = scale
      cell.yScale = scale

      var randomRotation = CGFloat(patternRandom.nextUniform()) * CGFloat.pi * 2.0
      if !(self.allowRandomRotation ?? allowRandomRotation) {
        randomRotation = 0.0
      }
      cell.zRotation = randomRotation

      wrapper.position.y = self.baseCellSize
      if (parameters.generation > 0) {
        
        wrapper.xScale = 1.0 + randomCumulativeScale
        wrapper.yScale = 1.0 + randomCumulativeScale
        
        wrapper.alpha = 1.0 - (CGFloat(patternRandom.nextUniform())*self.maxCumulativeAlphaDifference)
        wrapper.zRotation = randomCumulativeRotation
        
        var randomSeparation = CGFloat(patternRandom.nextInt(lowerBound: 8, upperBound: 30, bias: 0.5))
        if !(self.allowRandomSeparation ?? allowRandomSeparation) {
          randomSeparation = 10.0
        }
        wrapper.position.y = randomSeparation

      }
      
      
      //childNode.alpha = 0.99
      
      //      childNode.position.y = ((index == 1) ? -180 : 180)
      //
      //wrapper.run()
//
//      cell.yScale = 0.0
//      cell.xScale = 0.0
//      cell.alpha = 0.0
      
      let finalScaleY = cell.yScale
      let finalScaleX = cell.xScale
      
      let finalPosition = cell.position
      
      let spawn = SKAction.fadeIn(withDuration: self.revealAnimationDuration)
      let forever = SKAction.repeatForever(SKAction.customAction(withDuration: 1.0, actionBlock: { (node, deltaTime) in
        //node.zRotation = sin()*0.5
        node.position.x = sin((deltaTime)*CGFloat.pi*2) * 50.0
      }))
      
      var spawnAction: SKAction
      
      switch randomSpawnAnimation {
      case .fadeIn:
        let finalAlpha = cell.alpha
        cell.alpha = 0.0
        spawnAction = SKAction.fadeAlpha(to: finalAlpha, duration: self.revealAnimationDuration)
      default:
        spawnAction = SKAction.fadeAlpha(to: 0.0, duration: self.revealAnimationDuration)
      }

      cell.run(SKAction.sequence([SKAction.wait(forDuration: 0.04*Double(parameters.generation)),spawnAction]))
      
      wrapper.addChild(cell)
      
     // let pulse = SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: 1, duration: 100)]))
      //      pulse.timingMode = SKActionTimingMode.easeInEaseOut
      
      // wrapper.run(pulse)
      
      return wrapper
      
    }
    
    for _ in 1...random.nextInt(lowerBound: self.minBranches, upperBound: self.maxBranches) {
      self.replicationSchemas.append(repSchemaLeft)
    }
    
    self.replicate()
  }
  
  
  
  func recursiveReplicate(replicationSchema: ReplicationSchema, gen: Int, childIndex: Int, resultChild: SKNode, random: Random) {
    
    
    if gen > self.maxGenerations {
      return
    }
    
    let transformedChild = replicationSchema.replicatorFunction((childIndex, gen, random))
    resultChild.addChild(transformedChild)
    
    
    //let wrapper = SKNode()
    //wrapper.addChild(transformedChild)
    
    
    //resultChild.run(SKAction.rotate(byAngle: 1, duration: 10.0))
    if (replicationSchema.children.isEmpty) {
      self.recursiveReplicate(replicationSchema: replicationSchema, gen: gen + 1, childIndex: childIndex, resultChild: transformedChild, random: random)
    }
    for (i, childSchema) in replicationSchema.children.enumerated() {
      self.recursiveReplicate(replicationSchema: childSchema, gen: gen + 1, childIndex: i, resultChild: transformedChild, random: random)
    }
    
    //
    //    self.run(SKAction.sequence([
    //      SKAction.wait(forDuration: 0.2),
    //      SKAction.run { [weak self] in
    //        guard let `self` = self else {
    //          return
    //        }
    //
    //      }]))
    
    
  }
  
  
  func replicate() {
    
    let schemasSeed = "\(random.nextUniform())"
    let randomPatternPeriod = UInt(random.nextInt(lowerBound: 20, upperBound: self.maxGenerations, bias: 0.8))
    
    var first: SKNode!
    var last: SKNode!

    
    var finalpatch = SKNode()
    for (i,sh) in self.replicationSchemas.enumerated() {
      let wrapper = SKNode()

      
      wrapper.zRotation = CGFloat( (CGFloat.pi*2.0) / CGFloat(self.replicationSchemas.count) * CGFloat(i))
      
      
      let patternRandom = Random(seed: schemasSeed, period: self.patternPeriod ?? randomPatternPeriod)
      
      self.recursiveReplicate(replicationSchema: sh, gen: 0, childIndex: i, resultChild: wrapper, random: patternRandom)
      
      self.addChild(wrapper)
      if i < self.replicationSchemas.count/2 {
        finalpatch.addChild(wrapper.copy() as! SKNode)
      }
      
      last = wrapper
      
    }
    
    let cropnode = SKCropNode()
    cropnode.addChild(finalpatch)
    
    cropnode.maskNode = last
    
    self.addChild(cropnode)
    
    
  }
  
  
  public enum SpawnAnimation {
    case moveIn
    case fadeIn
    case growIn
  }
  
  public enum PerpetualAnimation {
    //case moveIn
    //case fadeIn
    //case growIn
  }
  
  
}
