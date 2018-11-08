//
//  Extensions.swift
//  2SetGame
//
//  Created by Chris Wu on 11/2/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import Foundation

extension Int {
    // MARK arc4random
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return Int(arc4random_uniform(UInt32(-self)))
        }
        else {
            return 0
        }
    }
    
    // MARK sameOrMutexIn3
    func sameOrMutexIn3(firstNumber:Int, secondNumber:Int) -> Bool
    {
        if firstNumber < 0 || firstNumber > 2 || secondNumber < 0 || secondNumber > 2 {
            return false
        }
        else if (firstNumber == secondNumber)
        {
            return self == secondNumber
        }
        else {
            return self != firstNumber && self != secondNumber
        }
    }
}
