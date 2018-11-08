
//
//  Card.swift
//  2SetGame
//
//  Created by Chris Wu on 11/2/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import Foundation

struct Card : Hashable, CustomStringConvertible{
    var description: String
    {
        return "c\(color) n\(number)\ns\(symbol) sh\(shading)"
    }
    
    var shortDescription: String {
        return "index=\(indexInDeck), state=\(state)"
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading
    }
    
    var indexInDeck = 0
    var color = 0
    var number = 0
    var symbol = 0
    var shading = 0
    var state = CardState.inDeck
    
    func isMatchCard(firstCard: Card, secondCard: Card) -> Bool {
        return
            self.color.sameOrMutexIn3(firstNumber: firstCard.color, secondNumber: secondCard.color) &&
                self.number.sameOrMutexIn3(firstNumber: firstCard.number, secondNumber: secondCard.number) &&
                self.symbol.sameOrMutexIn3(firstNumber: firstCard.symbol, secondNumber: secondCard.symbol) &&
                self.shading.sameOrMutexIn3(firstNumber: firstCard.shading, secondNumber: secondCard.shading)
    }
    
}

enum CardState: Int {
    case inDeck = 0
    case onDisplay = 1
    case chosen = 2
    case matched = 3
    case recycled = 4
    
}
