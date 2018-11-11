//
//  ViewController.swift
//  2SetGame
//
//  Created by Chris Wu on 11/2/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    private var chosenButtons = [UIButton]()

    private func bindButtons() {
        for index in 0 ..< buttons.count {
            let button = buttons[index]
            button.layer.cornerRadius = 8.0
            button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
            setHideCardStyle(button: button)
            
            if index < 12, game.hasMoreCardsInDeck, index < game.cards.count {
                if let card = game.drawNextCardForDisplay(replacedWith: nil) {
                    setCardOnDisplay(card: card, button: button)
                }
            }
        }
    }
    
    @IBOutlet weak var delMeThreeMoreButton: UIButton!
    
    @IBAction func deal3More(_ sender: UIButton) {
        //If three cards are choosen and they are matching, then just replace them with new cards
        if chosen3IsASet
        {
            setMatchedButtonsWithNewCards()
            game.deselectAll()
            chosenButtons.removeAll()
        }
        else {
            var counter = 0
            for index in 0 ..< buttons.count {
                let button = buttons[index]
                if button.tag == -1 && counter < 3 && game.hasMoreCardsInDeck
                {
                    if let card = game.drawNextCardForDisplay(replacedWith : nil) {
                        setCardOnDisplay(card: card, button: button)
                        counter += 1
                    }
                }
                else if !game.hasMoreCardsInDeck {
                    sender.isEnabled = false
                }
            }
            game.scale += 0.1
        }
        
        updateScore()
        checkError()
        //print("game.description = \(game.shortDescription)")
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        chosenButtons.removeAll()
        bindButtons()
        updateScore()
        chosen3IsASet = false
    }
    
    private func setChosen(button: UIButton) {
        if game.chooseCard(index: button.tag) {
            chosenButtons.append(button)
            setChosenStyle(button: button)
        }
    }
    
    private func setMatchedButtonsWithNewCards() {
        for index in 0 ... 2 {
            let button = chosenButtons[index]
            
            if let card = game.drawNextCardForDisplay(replacedWith: button.tag) {
                setCardOnDisplay(card: card, button: button)
            }
            else {
                delMeThreeMoreButton.isEnabled = false
                setHideCardStyle(button: button)
            }
        }
        
        game.deselectAll()
        chosenButtons.removeAll()
        chosen3IsASet = false
        
        if (!game.hasMoreCardsInDeck && game.findAMatchSet() == nil){
            print ("Game over")
            print (game.description)
        }
    }
    
    private func setCardMatched() {
        for index in 0 ... 2
        {
            setMatchedStyle(button: chosenButtons[index])
        }
        game.setChosen3Matched()
        chosen3IsASet = true
    }
    
    //MARK: Button Styles
    private func SetCardFace(card: Card, button: UIButton) {
        var myString = "Swift Attributed String"

        switch card.symbol {
        case 0 : myString = "●"
        case 1 : myString = "▲"
        case 2 : myString = "■"
        default : myString = ""
        }
        
        switch card.number {
        case 0 : break
        case 1 : myString += myString
        case 2 : myString += myString + myString
        default : myString = ""
        }
        
        var choiceColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        switch card.color {
        case 0 : choiceColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        case 1 : choiceColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case 2 : choiceColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        default : break
        }
        
        var myAttribute = [ NSAttributedString.Key: Any]()
        
        switch card.shading {
        case 0 :
            //Fill, 100% alpha and nagative strokeWidth
            myAttribute[NSAttributedString.Key.foregroundColor] = choiceColor
            myAttribute[NSAttributedString.Key.strokeWidth] = -5
            myAttribute[NSAttributedString.Key.strokeColor] = choiceColor
        case 1 :
            //Ouline, 100% alpha and positive strokeWicth
            myAttribute[NSAttributedString.Key.foregroundColor] = choiceColor
            myAttribute[NSAttributedString.Key.strokeWidth] = 8
            myAttribute[NSAttributedString.Key.strokeColor] = choiceColor

        case 2 :
            //Stripped, 15% alpha filled
            let fillColor = choiceColor.withAlphaComponent(0.30)
            myAttribute[NSAttributedString.Key.foregroundColor] = fillColor
            myAttribute[NSAttributedString.Key.strokeWidth] = -5
            myAttribute[NSAttributedString.Key.strokeColor] = fillColor

        default : break
        }
        
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)

        button.setAttributedTitle(myAttrString, for: .normal)
    }
    
    private func setChosenStyle(button: UIButton) {
        button.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
    }
    
    private func setSuggestionStyle(button: UIButton) {
        button.layer.borderColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1).cgColor
    }
    
    private func setMatchedStyle(button: UIButton) {
        button.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
    }
    
    private func SetNotMatchedStyle(button: UIButton) {
        button.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
    }
    
    private func setDisplayStyle(button: UIButton) {
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.isEnabled = true
    }
    
    private func setHideCardStyle(button: UIButton) {
        //Every button is at least go through this once, so the border width stuck
        button.backgroundColor = UIColor.black
        button.setAttributedTitle(nil, for: .normal)
        button.setTitle(nil, for: .normal)
        button.tag = -1
        button.isEnabled = false
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setCardOnDisplay(card: Card, button: UIButton) {
        button.tag = card.indexInDeck
        SetCardFace(card: card, button: button)
        setDisplayStyle(button: button)
    }
    
    private func resetCardOnDisplay(button: UIButton) {
        game.cards[button.tag].state = .onDisplay
        setDisplayStyle(button: button)
    }
    
    private func setCardNotMatch() {
        for index in 0 ... 2
        {
            SetNotMatchedStyle(button: chosenButtons[index])
        }
    }
    
    @IBOutlet weak var scoreLable: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    private func updateScore() {
        let formatedScore = String(format: "%.1f", game.scaledScore)
        scoreLable.text = (" Score: \(formatedScore)")
        
    }
    
    @IBAction func findMeASet(_ sender: UIButton) {
        //Deselect first
        for index in 0 ..< chosenButtons.count {
            resetCardOnDisplay(button: chosenButtons[index])
        }
        
        game.deselectAll()
        chosenButtons = [UIButton]()

        if let matchingSet = game.findAMatchSet() {
            //print ("match set found \(matchingSet.description)")
            for index in 0 ... 2 {
                if let button = buttons.first(where: { $0.tag == matchingSet[index] }) {
                    setSuggestionStyle(button: button)
                }
            }
        }
        else {
            let unMatched = game.cards.filter{ $0.state == .onDisplay }
            print("\(unMatched.count) cards can't be matched to any others")
            //print (game.shortDescription)
        }
        
        checkError()
        
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if chosenButtons.count < 3 {
            if chosenButtons.contains(sender) {
                // Deselection
                game.deselectCard(index: sender.tag)
                chosenButtons.removeAll(where: { $0.tag == sender.tag })
                
                resetCardOnDisplay(button: sender)
                game.scaledScore += -1/game.scale
            }
            else {
                setChosen(button: sender)
            }
        }
        else {
            // Before chosen the count already 3, this coule be either
            // 1. 3 matched + x onDisplay
            // 2. 3 chosen + x onDisplay
//            let allMatched = game.isTheChosen3ASet()
            var shouldChoose = true

            if chosenButtons.contains(sender) {
                shouldChoose = false
            }
            
            if (chosen3IsASet)
            {
                // the 3 cards are matched set
                setMatchedButtonsWithNewCards()
            }
            else {
                // No match but there are 3 cards chosen, they must be the unmatched ones
                for index in 0 ... 2 {
                    //Put all three back on table
                    resetCardOnDisplay(button: chosenButtons[index])
                    //print("after reset cards=\(game.cards.filter{ $0.state == .onDisplay })")
                }
                game.deselectAll()
                chosenButtons = [UIButton]()
            }
            
            
            if (!chosen3IsASet || shouldChoose) {
                setChosen(button: sender)
            }
            // Out State: all onDisplay or (n-1 on display and 1 chosen)
        }
        
        if chosenButtons.count == 3
        {
            if (game.isTheChosen3ASet())
            {
                setCardMatched()
                game.scaledScore += 3 / game.scale
            }
            else {
                setCardNotMatch()
                game.scaledScore -= 5 / game.scale
            }
        }
        
        updateScore()
        checkError()

    }
    
    private var chosen3IsASet = false
    
    private var numberOfButtonFaceUp: Int {
        return buttons.filter{ $0.tag > -1 }.count
    }
    
    private func checkError() {
        if (numberOfButtonFaceUp != game.numberOfCardsOnTable) {
            print("game error \n\(game.shortDescription)")
            for index in 0 ..< buttons.count {
                if buttons[index].tag > -1 {
                    print("buttons[\(index)]: \(buttons[index].tag); card=\(game.cards[buttons[index].tag].shortDescription)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButtons()
        print("uuidString = \(String(describing: UIDevice.current.identifierForVendor?.uuidString))")
    }
    
}

