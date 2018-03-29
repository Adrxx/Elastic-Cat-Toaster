//
//  ReplicationSchema.swift
//  RandoTests
//
//  Created by Adrián on 3/21/18.
//  Copyright © 2018 ment. All rights reserved.
//

import Foundation
import SpriteKit


public typealias ReplicationFunction = ((childIndex: Int, generation: Int, schemaRandom: Random)) -> SKNode

public class ReplicationSchema {
  
  public var children: [ReplicationSchema] = []
  
  public var replicatorFunction: ReplicationFunction
  
  public init(replicatorFunction: @escaping ReplicationFunction) {
    self.replicatorFunction = replicatorFunction
  }
  
}
