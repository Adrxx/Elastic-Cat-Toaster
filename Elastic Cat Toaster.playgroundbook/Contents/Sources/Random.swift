//
//  Random.swift
//  Elastic Cat Toaster
//
//  Created by Adrián on 3/23/18.
//  Copyright © 2018 ment. All rights reserved.
//


import GameplayKit

/// A helper class that can generate different random values but can also have a predefined `period` the define how fast the generated values will repeat. This is what makes the noticable patterns on the art pieces
public class Random: GKRandom {
  
  var period: UInt?
  
  private var randomSource: GKARC4RandomSource
  private var currentIteration = 0
  private let seedData: Data
  
  public init(seed: String, period: UInt? = nil) {
    var cleanSeed = seed
    if seed == "" {
      cleanSeed = "Random seed"
    }
    self.period = period
    self.seedData = cleanSeed.data(using: .utf8)!
    self.randomSource = GKARC4RandomSource(seed: self.seedData)
  }
  
  private func incrementPeriod() {
    if let period = self.period {
      if self.currentIteration > period {
        // Reset random
        self.reset()
        self.currentIteration = 0
      } else {
        self.currentIteration += 1
      }
    }
  }
  
  public func choiceFrom<Element>(_ array: Array<Element>) -> Element? {
    if array.isEmpty {
      return nil
    }
    return array[self.nextInt(upperBound: array.count)]
  }
  
  public func nextInt(lowerBound: Int, upperBound: Int) -> Int {
    let randomDistribution = GKRandomDistribution(randomSource: self, lowestValue: lowerBound, highestValue: upperBound)
    return randomDistribution.nextInt()
  }
  
  public func nextInt(lowerBound: Int, upperBound: Int, bias: Float) -> Int {
    let clippedBias = max(min(bias, 1.0),0.0)
    let distanceBetweenValues = Float(lowerBound.distance(to: upperBound))
    
    let mean = Float(lowerBound) + (distanceBetweenValues * clippedBias)
    
    let gaussianDistribution = GKGaussianDistribution(randomSource: self, mean: mean, deviation: distanceBetweenValues/2)
    return min(max(gaussianDistribution.nextInt(),lowerBound),upperBound)
  }
  
  public func nextInt() -> Int {
    let result = self.randomSource.nextInt()
    self.incrementPeriod()
    return result
  }
  
  public func nextInt(upperBound: Int) -> Int {
    let result = self.randomSource.nextInt(upperBound: upperBound)
    self.incrementPeriod()
    return result
  }
  
  public func nextUniform() -> Float {
    let result =  self.randomSource.nextUniform()
    self.incrementPeriod()
    return result
  }
  
  public func nextBool() -> Bool {
    let result =  self.randomSource.nextBool()
    self.incrementPeriod()
    return result
  }
  
  public func reset() {
    self.randomSource = GKARC4RandomSource(seed: self.seedData)
  }
  
  public func dropValues(count: Int) {
    self.randomSource.dropValues(count)
  }
  
  
}

