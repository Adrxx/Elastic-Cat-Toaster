//
//  Grid.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/17/18.
//  Copyright © 2018 ment. All rights reserved.
//

import SpriteKit

/// A Grid lays down instances of `SKSpriteNode` in a grid and applies different properties like the size, color and shape to each sprite. This properties are randomly applied by the `Random` class.
public class Grid: ArtScene {
  
  /// A predifined style for the art piece, for more info about each style, tap help on the `Style` enum
  public var style: Style?
  
    /// This number defines how much it takes for the random sequence of genereted by the `Random` class to repeat. A shorter value means a simple pattern, a larger value means a complex pattern.
  public var patternComplexity: UInt?
  
  /// This defines how divided the grid will be, a higher value will create more divisions and ìn turn, smaller `SKSpriteNode`s.
  public var cellDivision: CGFloat?
  /// The color of the background.
  public var canvasColor: UIColor?
  /// The image used for the shape of every `SKSpriteNode` that appears.
  public var cellImage: UIImage?
  /// The color used for the shape of every `SKSpriteNode` that appears. If thois property is set, it overrides the `colorPalette` definition.
  public var cellColor: UIColor?
  /// The scale of of every `SKSpriteNode` that appears.
  public var cellScale: CGFloat?
  public var allowOffsets: Bool? = false
  
  /// The color palette that the art piece uses.
  public var colorPalette: [UIColor]?
  public var possibleSprites: [UIImage]?
  
  /// If true, random horizontal and vertical axis flips may ocurr on the `SKSpriteNode`s.
  public var allowFlips: Bool?
  /// If true, each `SKSpriteNode` is calculated with a random scale.
  public var allowRandomScale: Bool?
  public var revealAnimationDuration: TimeInterval = 0.4
  public var randomScaleFactor: CGFloat = 3.0
  
  override func drawScene() {
    super.drawScene()
    
    let randomStyle = random.choiceFrom([Style.chaos,Style.flat,Style.pixel])!
    var _style = self.style ?? randomStyle
    if self.style == .random {
      _style = randomStyle
    }
    
    let randomColorPalette = random.choiceFrom(_style.palettes())!
    let _colorPalette = self.colorPalette ?? randomColorPalette
    let _possibleSprites = self.possibleSprites ?? _style.sprites()
    
    // Get the greatest common divisor for perfect square cells that fit both dimensions.
    //let gcd = Utils.gcd(Int(self.frame.height),Int(self.frame.width))
    // This would work perfectly on all screens if they all had perfect
    // Aspect ratios, but this is going for an iPad which is always 3:4
    // Let's just stick to that...s
    let gcd: CGFloat = 256
    
    var randomCellDivision: CGFloat
    switch _style {
    case .chaos:
      randomCellDivision = CGFloat(random.nextInt(lowerBound: 4, upperBound: 21, bias: 0.9))
    case .flat:
      randomCellDivision = CGFloat(random.nextInt(lowerBound: 4, upperBound: 21, bias: 0.5))
    case .pixel:
      randomCellDivision = CGFloat(random.nextInt(lowerBound: 4, upperBound: 21))
    default:
      return
    }
    
    let cappedCellDivision = max(self.cellDivision ?? randomCellDivision, 1.0)
    
    let cellSize = CGFloat(gcd) / cappedCellDivision
    
    
    let randomCanvasColor = random.choiceFrom(_colorPalette)!
    self.backgroundColor = self.canvasColor ?? randomCanvasColor
    
    // Setup grid
    let columnsCount = Int(ceil(self.frame.height/cellSize))
    let rowsCount = Int(ceil(self.frame.width/cellSize))
    let size = CGSize(width: cellSize, height: cellSize)
    
    let randomTexture = random.choiceFrom(_possibleSprites)!
    let texture = SKTexture(image: self.cellImage ?? randomTexture)
    
    var randomPatternPeriod: UInt
    switch _style {
    case .chaos:
      randomPatternPeriod = UInt(random.nextInt(lowerBound: 30, upperBound: 90, bias: 0.2))
    case .flat:
      randomPatternPeriod = UInt(random.nextInt(lowerBound: 30, upperBound: 80, bias: 0.5))
    case .pixel:
      randomPatternPeriod = UInt(random.nextInt(lowerBound: 40, upperBound: 120, bias: 0.4))
    default:
      return
    }
    
    let allowRandomScale = (random.nextInt(lowerBound: 0, upperBound: 10) > 5)
    let spawnAnimationMoveIn = random.nextBool()
    
    
    let patternRandom = Random(seed: "\(random.nextUniform())", period: self.patternComplexity ?? randomPatternPeriod)
    
    for rows in 0...rowsCount {
      for columns in 0...columnsCount {
        
        let cell = SKSpriteNode(texture: texture, size: size)
        
        // Setup the nodes in a grid
        cell.position.x = (CGFloat(rows) + 0.5) * cellSize
        //cell.position.x -= self.frame.width/2
        cell.position.y = (CGFloat(columns) + 0.5) * cellSize
        //cell.position.y -= self.frame.height/2
        
        let yOffset = CGFloat(patternRandom.nextUniform()-0.5) * (cellSize/2)
        let xOffset = CGFloat(patternRandom.nextUniform()-0.5) * (cellSize/2)
        // Only chaos style should allow offsets
        if self.allowOffsets ?? (_style == .chaos) {
          cell.position.y += yOffset
          cell.position.x += xOffset
        }
        
        let randomColor = patternRandom.choiceFrom(_colorPalette)!
        cell.color = self.cellColor ?? randomColor
        cell.colorBlendFactor = 1.0
        
        cell.alpha = CGFloat(patternRandom.nextUniform())
        var randomScale = CGFloat(patternRandom.nextUniform()) * self.randomScaleFactor
        if !(self.allowRandomScale ?? allowRandomScale) {
          randomScale = 1.0
        }
        let scale = self.cellScale ?? randomScale
        
        // Let's keep the aspect ratio
        cell.xScale = scale
        cell.yScale = scale
        
        var yFlipper: CGFloat = patternRandom.nextBool() ? 1 : -1
        var xFlipper: CGFloat = patternRandom.nextBool() ? 1 : -1
        
        let alternatedFlipper = patternRandom.nextBool()
        
        if alternatedFlipper {
          yFlipper = (columns % 2 == 0) ? -1 : 1
          xFlipper = (rows % 2 == 0) ? -1 : 1
        }
        
        if self.allowFlips ?? (_style == .flat) {
          cell.xScale *= xFlipper
          cell.yScale *= yFlipper
        }
        
        let finalScaleY = cell.yScale
        let finalScaleX = cell.xScale
        
        let finalAlpha = cell.alpha
        let finalPosition = cell.position
        cell.alpha = 0.0
        
        let moveIn = SKAction.move(to: finalPosition, duration: self.revealAnimationDuration)
        let growIn = SKAction.group([SKAction.scaleY(to: finalScaleY, duration: self.revealAnimationDuration),SKAction.scaleX(to: finalScaleX, duration: self.revealAnimationDuration)])
        
        var randomSpawnAnimation: SKAction
        if spawnAnimationMoveIn {
          cell.position.x += CGFloat(patternRandom.nextUniform()-0.5) * (cellSize*3)
          cell.position.y += CGFloat(patternRandom.nextUniform()-0.5) * (cellSize*3)
          randomSpawnAnimation = moveIn
        } else {
          cell.xScale = 0.0
          cell.yScale = 0.0
          randomSpawnAnimation = growIn
        }
        
        randomSpawnAnimation.timingMode = .easeInEaseOut
        let fadeIn = SKAction.fadeAlpha(to: finalAlpha, duration: self.revealAnimationDuration)
        fadeIn.timingMode = .easeInEaseOut
        let spawn = SKAction.group([
          fadeIn,
          randomSpawnAnimation,
          ])
        
        let randomSpawnTime = TimeInterval(patternRandom.nextUniform()) * self.revealAnimationDuration
        let appear = SKAction.sequence([SKAction.wait(forDuration: randomSpawnTime),spawn])
        
        cell.run(appear)
        
        self.addChild(cell)
      }
    }
  }
  
  
  /// A predifined style for each art piece
  ///
  /// - random: Random style.
  /// - flat: A flat style uses mostly triangular shapes that are just flipped on their x and y axes, generally without scaling them.
  /// - chaos: No rules, anyhting can happen
  /// - pixel: A style that ressembles a pixelatted screen.
  public enum Style {
    
    case random
    case flat
    case chaos
    case pixel
    
    func palettes() -> [[UIColor]] {
      return [
        Colors.abercrombie,
        Colors.aperture,
        Colors.eighties,
        Colors.emoGirl,
        Colors.native,
        Colors.zombie,
        Colors.violet,
        Colors.insta,
        Colors.olde,
        Colors.ocean,
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
      ]
    }
    
    func sprites() -> [UIImage] {
      switch self {
      case .chaos:
        return [#imageLiteral(resourceName: "App"),#imageLiteral(resourceName: "Square"),#imageLiteral(resourceName: "Circle"),#imageLiteral(resourceName: "Circle"),#imageLiteral(resourceName: "Hexagon")]
      case .pixel:
        return [#imageLiteral(resourceName: "Square")]
      case .flat:
        return [#imageLiteral(resourceName: "Skewed"),#imageLiteral(resourceName: "Half-Triangle")]
      default:
        return []
      }
    }
  }
  
  
}

