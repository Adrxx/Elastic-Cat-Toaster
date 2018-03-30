//#-hidden-code
import UIKit
import PlaygroundSupport

let artView = ArtView(title: "Grid", frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//#-end-hidden-code
/*:
 This one here is called **Echo** and unlike the last piece, this one actually *moves*. Echo uses a technique I call *replicators*.
 
 A Replicator starts as a simple `SKSpriteNode` but uses a `TransformationFunction` to create a slighlty different copy of itself. The small changes add up in an exponential way, and can lead to some really impresive results.
 
 Enough explanation, **Run the code**. Remember you can **swipe left** to see the next variant in the sequence. Oh, and you might want to go fullscreen on this one. 🙌
 
 You can play with the properties below as well, when you are done, go to the next page: [Thank you](@next)!
 */
let seed = /*#-editable-code Random seed*/"I always finish my sente..."/*#-end-editable-code*/
let random = Random(seed: seed)
artView.regenerate = { (i) -> ArtScene in
  
  // If you want to skip to a certain variant in the sequence.
  //#-code-completion(everything, hide)
  let fastForward = /*#-editable-code*/15/*#-end-editable-code*/
  
  let replicator = Replicator(seed: seed, dropValues: i + fastForward, size: artView.frame.size)
  
  // Animations
  //#-code-completion(identifier, show, fadeIn, random, growIn, none, ., nil)
  replicator.spawnAnimation = Replicator.SpawnAnimation/*#-editable-code*/.random/*#-end-editable-code*/
  //#-code-completion(identifier, show, pulse, random, lag, wave, flash, swing, tornado)
  replicator.perpetualAnimation = Replicator.PerpetualAnimation/*#-editable-code*/.random/*#-end-editable-code*/
  
  // Shapes
  //#-code-completion(everything, show)
  replicator.cellImage = Images/*#-editable-code*/.random/*#-end-editable-code*/
  
  // Colors
  replicator.colorPalette = Colors/*#-editable-code*/.random/*#-end-editable-code*/
  //#-code-completion(everything, hide)
  //#-code-completion(identifier, hide, ., random)
  //#-code-completion(literal, show, color)
  replicator.cellColor = /*#-editable-code*/nil/*#-end-editable-code*/
  replicator.canvasColor = /*#-editable-code*/nil/*#-end-editable-code*/
  
  // Sizes
  //#-code-completion(literal, show, integer)
  replicator.cellScale = /*#-editable-code*/nil/*#-end-editable-code*/
  //#-code-completion(identifier, show, true, false)
  replicator.allowRandomScale = /*#-editable-code*/nil/*#-end-editable-code*/

  // Pattern
  //#-code-completion(literal, show, integer)
  replicator.patternComplexity = /*#-editable-code*/nil/*#-end-editable-code*/
  
  // Positions
  //#-code-completion(identifier, show, true, false)
  replicator.allowRandomSeparation = /*#-editable-code*/nil/*#-end-editable-code*/
  replicator.allowRandomRotation = /*#-editable-code*/nil/*#-end-editable-code*/
  
  return replicator
}
//#-hidden-code
PlaygroundPage.current.liveView = artView
//#-end-hidden-code
