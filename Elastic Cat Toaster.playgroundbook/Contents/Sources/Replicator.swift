//
//  Replicator.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/21/18.
//  Copyright © 2018 ment. All rights reserved.
//

//
import SpriteKit


/// A Replicator uses a collection`ReplicationSchema` to reproduce a series of `SKSpriteNode`'s. Each generation being slightly changed by a transformation function.
public class Replicator: ArtScene {
  
  public let maxBranches = 12
  public let minBranches = 2
  
  public let baseCellSize: CGFloat = 60.0
  public let maxCumulativeScaleRange: CGFloat = 0.16
  public let maxCumulativeRotationRange: CGFloat = 0.08
  public let maxCumulativeAlphaDifference: CGFloat = 0.08
  public let maxGenerations = 80
  public let separationAngle = CGFloat.pi/2
  public let revealAnimationDuration: TimeInterval = 0.4
  public let randomScaleFactor: CGFloat = 1.7

  /// This number defines how much it takes for the random sequence of genereted by the `Random` class to repeat. A shorter value means a simple pattern, a larger value means a complex pattern.
  public var patternComplexity: UInt?
  
  /// The image used for the shape of every `SKSpriteNode` that appears.
  public var cellImage: UIImage?
  
  /// The color used for the shape of every `SKSpriteNode` that appears. If thois property is set, it overrides the `colorPalette` definition.
  public var cellColor: UIColor?

  /// The scale of of every `SKSpriteNode` that appears.
  public var cellScale: CGFloat?
  
  /// The animation for when a `SKSpriteNode` appears, for more info about the possible options, use help on the `SpawnAnimation` enum.
  public var spawnAnimation: SpawnAnimation = .random
  /// The animation that loops forever after a `SKSpriteNode` appears. for more info about the possible options, use help on the `PerpetualAnimation` enum.
  public var perpetualAnimation: PerpetualAnimation = .random
  public var perpetualAnimationSpeed: UInt?
  
  /// The color of the background.
  public var canvasColor: UIColor?
  
  /// If true, each `SKSpriteNode` is calculated with a random scale.
  public var allowRandomScale: Bool?
  
  // If true, the distance between each generation of `SKSpriteNode` is randomly calculated.
  public var allowRandomSeparation: Bool?
  
  // If true, the rotation of every `SKSpriteNode` is randomly calculated.
  public var allowRandomRotation: Bool?
  public var allowAlphaDecay: Bool?
  
  /// The color palette that the art piece uses.
  public var colorPalette: [UIColor]?
  
  private var replicationSchemas: [ReplicationSchema] = []
  
  private let colorPalettes =  [
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
    Colors.aperture,
    Colors.insta,
    Colors.olde,
    Colors.ocean
  ]
  
  private let possibleTextures = [#imageLiteral(resourceName: "App"),#imageLiteral(resourceName: "Square"),#imageLiteral(resourceName: "Circle"),#imageLiteral(resourceName: "Hexagon"),#imageLiteral(resourceName: "Skewed"),#imageLiteral(resourceName: "Half-Triangle"),#imageLiteral(resourceName: "Boom"),#imageLiteral(resourceName: "Triangle")]
  
  override public func sceneDidLoad() {
    super.sceneDidLoad()
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
  
  override func drawScene() {
    super.drawScene()
    
    let size = CGSize(width: self.baseCellSize, height: self.baseCellSize)
    
    let randomTexture = random.choiceFrom(possibleTextures)!
    let texture = SKTexture(image: self.cellImage ?? randomTexture)
    
    let colorPalette = random.choiceFrom(self.colorPalettes)!
    let randomColorPalette = self.colorPalette ?? colorPalette
    
    let randomCanvasColor = random.choiceFrom(randomColorPalette)!
    self.backgroundColor = self.canvasColor ?? randomCanvasColor
    
    let randomCumulativeScale = (CGFloat(random.nextUniform()) * self.maxCumulativeScaleRange) - self.maxCumulativeScaleRange/2.0
    
    let randomCumulativeRotation = (CGFloat(random.nextUniform()) * self.maxCumulativeRotationRange) - self.maxCumulativeRotationRange/2.0
    
    let allowRandomScale = (random.nextInt(lowerBound: 0, upperBound: 10) > 5)
    let allowRandomSeparation = (random.nextInt(lowerBound: 0, upperBound: 10) > 9)
    let allowRandomRotation = (random.nextInt(lowerBound: 0, upperBound: 10) > 8)
    let allowAlphaDecay = (random.nextInt(lowerBound: 0, upperBound: 10) > 6)
    
    let randomSpawnAnimation: SpawnAnimation = random.choiceFrom([.fadeIn,.growIn])!
    let randomPerpetualAnimation: PerpetualAnimation = random.choiceFrom([.pulse,.flash,.swing,.lag,.wave,.tornado])!
    let perpetualAnimationSpeed = CGFloat(random.nextInt(lowerBound: 2, upperBound: 10, bias: 0.0))

    
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
      
      wrapper.xScale = 1.0 + randomCumulativeScale
      wrapper.yScale = 1.0 + randomCumulativeScale
      
      let alphaDifference = (CGFloat(patternRandom.nextUniform())*self.maxCumulativeAlphaDifference)
      if self.allowAlphaDecay ?? allowAlphaDecay {
        wrapper.alpha = 1.0 - alphaDifference
      }
      wrapper.zRotation = randomCumulativeRotation
      
      var randomSeparation = CGFloat(patternRandom.nextInt(lowerBound: 8, upperBound: 30, bias: 0.5))
      if !(self.allowRandomSeparation ?? allowRandomSeparation) {
        randomSeparation = 10.0
      }
      wrapper.position.y = randomSeparation
      
      
      if (parameters.generation == 0) {
        wrapper.position.y = self.baseCellSize
      }
      
      let finalAlpha = cell.alpha
      let finalScaleY = cell.yScale
      let finalScaleX = cell.xScale
      let finalRotation = cell.zRotation
      
      var spawnAction: SKAction
      switch (self.spawnAnimation == .random ? randomSpawnAnimation : self.spawnAnimation) {
      case .fadeIn:
        cell.alpha = 0.0
        spawnAction = SKAction.fadeAlpha(to: finalAlpha, duration: self.revealAnimationDuration)
      case .growIn:
        cell.xScale = 0.01
        cell.yScale = 0.01
        spawnAction = SKAction.group([SKAction.scaleY(to: finalScaleY, duration: self.revealAnimationDuration),SKAction.scaleX(to: finalScaleX, duration: self.revealAnimationDuration)])
      default:
        spawnAction = SKAction.fadeAlpha(by: 0.0, duration: 0.0)
      }
      
      
      // perpetual animations
      
      var perpetualAction: SKAction
      switch (self.perpetualAnimation == .random ? randomPerpetualAnimation : self.perpetualAnimation) {
      case .wave:
        perpetualAction = SKAction.customAction(withDuration: TimeInterval(perpetualAnimationSpeed), actionBlock: { (node, deltaTime) in
          node.position.x = sin((deltaTime/perpetualAnimationSpeed)*CGFloat.pi*2) * 50.0
        })
      case .pulse:
        perpetualAction = SKAction.customAction(withDuration: TimeInterval(perpetualAnimationSpeed), actionBlock: { (node, deltaTime) in
          let delta = sin((deltaTime/perpetualAnimationSpeed)*CGFloat.pi*2) * 0.3
          node.xScale = finalScaleX + delta
          node.yScale = finalScaleY + delta
        })
      case .lag:
        perpetualAction = SKAction.customAction(withDuration: TimeInterval(perpetualAnimationSpeed), actionBlock: { (node, deltaTime) in
          node.position.y = sin((deltaTime/perpetualAnimationSpeed)*CGFloat.pi*2) * (self.baseCellSize/3.0)
        })
      case .flash:
        perpetualAction = SKAction.customAction(withDuration: TimeInterval(perpetualAnimationSpeed), actionBlock: { (node, deltaTime) in
          node.alpha = finalAlpha - sin((deltaTime/perpetualAnimationSpeed)*CGFloat.pi)
        })
      case .swing:
        perpetualAction = SKAction.customAction(withDuration: TimeInterval(perpetualAnimationSpeed), actionBlock: { (node, deltaTime) in
          node.zRotation = finalRotation + sin((deltaTime/perpetualAnimationSpeed)*CGFloat.pi*2)*0.1
        })
      case .tornado:
        perpetualAction = SKAction.rotate(byAngle: 0.5*CGFloat(parameters.generation), duration: TimeInterval(perpetualAnimationSpeed))
      default:
        perpetualAction = SKAction.fadeAlpha(by: 0.0, duration: 0.0)
      }
      //perpetualAction.timingMode = .easeInEaseOut
      
      cell.run(SKAction.sequence([SKAction.wait(forDuration: 0.04*Double(parameters.generation)),spawnAction, SKAction.repeatForever(perpetualAction)]))
      
      wrapper.addChild(cell)
      
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

    if (replicationSchema.children.isEmpty) {
      self.recursiveReplicate(replicationSchema: replicationSchema, gen: gen + 1, childIndex: childIndex, resultChild: transformedChild, random: random)
    }
    for (i, childSchema) in replicationSchema.children.enumerated() {
      self.recursiveReplicate(replicationSchema: childSchema, gen: gen + 1, childIndex: i, resultChild: transformedChild, random: random)
    }
    
  }
  
  
  func replicate() {
    
    let everything = SKNode()
    
    let schemasSeed = "\(random.nextUniform())"
    let randomPatternPeriod = UInt(random.nextInt(lowerBound: 20, upperBound: self.maxGenerations, bias: 0.8))
    
    var last: SKNode!
    
    
    let finalpatch = SKNode()
    for (i,sh) in self.replicationSchemas.enumerated() {
      let wrapper = SKNode()
      
      
      wrapper.zRotation = CGFloat( (CGFloat.pi*2.0) / CGFloat(self.replicationSchemas.count) * CGFloat(i))
      
      
      let patternRandom = Random(seed: schemasSeed, period: self.patternComplexity ?? randomPatternPeriod)
      
      self.recursiveReplicate(replicationSchema: sh, gen: 0, childIndex: i, resultChild: wrapper, random: patternRandom)
      
      everything.addChild(wrapper)
      
      if i < self.replicationSchemas.count/2 {
        finalpatch.addChild(wrapper.copy() as! SKNode)
      }
      
      last = wrapper
      
    }
    
    let cropnode = SKCropNode()
    cropnode.addChild(finalpatch)
    cropnode.maskNode = last
    everything.addChild(cropnode)
    everything.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi*2, duration: 60.0)))
    
    self.addChild(everything)
  }
  
  
  
  /// The animation for when a `SKSpriteNode` appears, for more info about the possible options, use help on the `SpawnAnimation` enum.
  ///
  /// - fadeIn: Each `SKSpriteNode` fades to its final alpha.
  /// - growIn: Each `SKSpriteNode` grows to its final scale.
  /// - none: No animation.
  /// - random: Randomly selected animation.
  public enum SpawnAnimation {
    case fadeIn
    case growIn
    case none
    case random
  }
  
  /// The animation that loops forever after a `SKSpriteNode` appears. for more info about the possible options, use help on the `PerpetualAnimation` enum.
  ///
  /// - none: No animation.
  /// - random: Randomly selected animation.
  /// - pulse: This animation changes scale of each `SKSpriteNode` back and forth with a slight delay on each generation.
  /// - lag: This animation changes the separation between each `SKSpriteNode` with a slight delay on each generation.
  /// - wave: This animation changes the horizontal position of each `SKSpriteNode` with a slight delay on each generation to create a wavy effect.s
  /// - flash: This animation changes the alpha of each `SKSpriteNode` from 0.0 to 1.0 and back with a slight delay on each generation.
  /// - swing: This animation changes the rotation of each `SKSpriteNode` back and forth with a slight delay on each generation.
  /// - tornado: This animation rotates each `SKSpriteNode` faster depending on it's generation, early `SKSpriteNode`s will have slow rotation, and for every generation after that, the rotation speed will grow.
  public enum PerpetualAnimation {
    case none
    case random
    case pulse
    case lag
    case wave
    case flash
    case swing
    case tornado
  }
  
  
}

