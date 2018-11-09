//
//  SetGame.swift
//  2SetGame
//
//  Created by Chris Wu on 11/2/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import Foundation

class SetGame: CustomStringConvertible {
    // MARK: Instance variables
    private var chosenCardIndeces = [Int]()
    private var runnerIndex = 0
    var scale = 1.0
    var scaledScore = 0.0
    var cards = [Card]()
    
    // MARK: APIs
    var numberOfCardsOnTable: Int {
        return cards.filter{ $0.isCardOnTable }.count
    }
    
    var shortDescription: String {
        var retval = ""
        retval = "runnerIndex = \(runnerIndex)\n"
        retval += "chosen Indices = \(chosenCardIndeces.description)\n"
        retval += "total cards on display = \(cards.filter{ $0.state == .onDisplay }.count)\n"
        retval += "total cards chosen = \(cards.filter{ $0.state == .chosen }.count)\n"
        
        return retval
    }
    
    var description: String {
        var retval = shortDescription
        for index in 0..<cards.count{
            retval += "i[\(index)]" + cards[index].description + "\n" + cards[index].shortDescription + "\n"
        }
        return retval
    }
    
    var hasMoreCardsInDeck: Bool {
        return runnerIndex < cards.count
    }
    
    // MARK: Init(dim)
    init() {
        var card = Card()
        chosenCardIndeces = [Int]()
        runnerIndex = 0
        //score = 0
        scale = 1.0
        scaledScore = 0.0
        
        //Set the dimention of the game, it can handle 2 to 4
        let dimension = 4
                
        for firstRound in 0...2
        {
            card.color = firstRound
            for secondRound in 0...2
            {
                card.number = secondRound
                card.symbol = 0
                card.shading = 0
                if (dimension > 2)
                {
                    for thirdRound in 0...2
                    {
                        card.symbol = thirdRound
                        if (dimension == 4)
                        {
                            for fourthRound in 0...2
                            {
                                card.shading = fourthRound
                                let v = cards.count.arc4random
                                //print("count=\(cards.count), random=\(v)")
                                cards.insert(card, at: v)
                            }
                        }
                        else{
                            let v = cards.count.arc4random
                            //print("count=\(cards.count), random=\(v)")
                            cards.insert(card, at: v)
                        }
                    }
                }
                else {
                    let v = cards.count.arc4random
                    //print("count=\(cards.count), random=\(v)")
                    cards.insert(card, at: v)
                }
            }
        }
        
        let v = cards.count.arc4random
        //print("count=\(cards.count), random=\(v)")
        cards.insert(cards[cards.count - 1], at: v)
        
        //print("count=\(cards.count)")
        cards.remove(at: cards.count - 1)
        
        //Set the index
        for index in 0 ..< cards.count {
            cards[index].indexInDeck = index
        }
        
        var sameCardFound = false
        for i1 in 0 ..< cards.count {
            for i2 in 0 ..< cards.count {
                if (i1 != i2 ) && (cards[i1] == cards[i2]) {
                    print("Bad Deck: Same cards found: card1 = \(cards[i1].description) card2 = \(cards[i2].description)")
                    sameCardFound = true
                    break
                }
            }
        }
        if (!sameCardFound)
        {
            print("Good deck")
            //print(cards.description)
        }
    }
    
    func chooseCard(index: Int) -> Bool {
        if chosenCardIndeces.count < 3, cards.indices.contains(index), cards[index].canChoose {
            cards[index].state = .chosen
            chosenCardIndeces.append(index)
            return true
        }
        else {
            return false
        }
    }
    
    func deselectCard(index: Int) {
        if chosenCardIndeces.contains(index), cards.indices.contains(index), cards[index].state == .chosen {
            cards[index].state = .onDisplay
            chosenCardIndeces.removeAll(where: {$0 == index})
        }
    }
    
    func setChosen3Matched()
    {
        for index in chosenCardIndeces {
            cards[index].state = .matched
        }
    }
    
    func deselectAll() {
        for index in chosenCardIndeces.indices {
            if cards[chosenCardIndeces[index]].state == .chosen {
                cards[chosenCardIndeces[index]].state = .onDisplay
            }
        }
        chosenCardIndeces.removeAll()
    }
    
    func drawNextCardForDisplay(replacedWith recycleIndex: Int?) -> Card? {
        if let index = recycleIndex, cards.indices.contains(index) {
            cards[index].state = .recycled
        }
        
        var retval: Card?
        if hasMoreCardsInDeck {
            cards[runnerIndex].state = .onDisplay
            retval = cards[runnerIndex]
            
            runnerIndex += 1
        }
        else {
            retval = nil
        }
        return retval
    }
    
    func isTheChosen3ASet() -> Bool {
        assert(chosenCardIndeces.count < 4, "Internal error, more than 3 cards chosen")
        
        var retval = false
        if chosenCardIndeces.indices.count < 3 {
            retval = false
        }
        else if chosenCardIndeces.indices.count == 3 {
            retval = cards[chosenCardIndeces[0]].matchesWithOtherTwo(firstCard: cards[chosenCardIndeces[1]], secondCard: cards[chosenCardIndeces[2]])
        }
        
        return retval
    }
    
    func findAMatchSet() -> [Int]? {
        for i1 in 0 ..< cards.count {
            for i2 in i1 + 1 ..< cards.count {
                for i3 in i2 + 1 ..< cards.count {
                    if cards[i1].state == .onDisplay && cards[i2].state == .onDisplay && cards[i3].state == .onDisplay  && cards[i1].matchesWithOtherTwo(firstCard: cards[i2], secondCard: cards[i3]) {
                        return [i1, i2, i3]
                    }
                }
            }
        }
        return nil
    }
}
