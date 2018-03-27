//
//  Utils.swift
//  RandoTests
//
//  Created by Adrián on 3/23/18.
//  Copyright © 2018 ment. All rights reserved.
//

import Foundation


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
