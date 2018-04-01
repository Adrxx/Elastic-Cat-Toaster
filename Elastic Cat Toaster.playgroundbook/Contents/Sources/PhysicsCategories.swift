//
//  PhysicsCategories.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/29/18.
//  Copyright © 2018 ment. All rights reserved.
//

import Foundation

/// The categories for the Canvas Scene
public struct PhysicsCategory {
  
  public static let none: UInt32 = 0b0
  public static let all: UInt32 = UInt32.max
  public static let painter: UInt32 = (0b1 << 0)
  public static let painterParticle: UInt32 = (0b1 << 1)
  public static let walls: UInt32 = (0b1 << 2)
  public static let commonFields: UInt32 = (0b1 << 6)
  public static let painterField: UInt32 = (0b1 << 3)
  public static let painterParticleField: UInt32 = (0b1 << 4)
  public static let oppositePainterField: UInt32 = (0b1 << 5)

}
