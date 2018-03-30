import UIKit
import PlaygroundSupport
let artView = ArtView(title: "Thanks", frame: CGRect(x: 0, y: 0, width: 200, height: 200))
let seed = "Please let me go to WWDC 2018"
let random = Random(seed: seed)
artView.isUserInteractionEnabled = false
artView.regenerate = { (i) -> ArtScene in

  let canvas = Canvas(seed: seed, dropValues: 0, size: artView.frame.size)
  
  return canvas
}
PlaygroundPage.current.liveView = artView

