//
//  Utils.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/23/18.
//  Copyright © 2018 ment. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
  static func gcd(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    if r != 0 {
      return gcd(b, r)
    } else {
      return b
    }
  }
}

extension CGPoint {
  var reflected: CGPoint {
    return CGPoint(x: -self.x, y: -self.y)
  }
}

extension CGVector {
  var reflected: CGVector {
    return CGVector(dx: -self.dx, dy: -self.dy)
  }
}

