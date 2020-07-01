//
//  ViewController.swift
//  Memorama
//
//  Created by Carlos Cardona on 10/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    var timer:Timer?
    var milliseconds:Int = 10 * 1000
    var firstFlippedCradIndex: IndexPath?
    var soundPlayer = SoundManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()
        
        // Set the view controller as the DataSource and Delegate of the Collection View
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 1 / 1000, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: Timer methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches Zero
        
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // TODO: check if the user has cleared all the cards
            
            checkForGameEnd()
        }
        
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // retunrn number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // configure the state of the cell in base of the porperties on the Card that it reperesnts
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Configure th Cell
        cardCell?.configureCell(card: card)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time remaining. Don't let the user interactwith the cards if the time is 0
        if milliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            
            // Flip the card up
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // chech if this es the first card that is flipped or the second one
            
            if firstFlippedCradIndex == nil {
                
                // This is the first card flipped over
                
                firstFlippedCradIndex = indexPath
                
            } else {
                
                // This is the second card that is flipped
                // run the comparison logic
                
                checkForMatch(indexPath)
                
            }
        }
    }
    
    
    
    // MARK: Game logic methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the two card objects for the indices and see if they match
        
        let cardOne = cardsArray[firstFlippedCradIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // get the two collection view cells that represent cardOne and cardTwo
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCradIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // compare rhe two cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            // its a match
            
            // Play sound
            soundPlayer.playSound(effect: .match)
            // set the status and remove them
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was the last pair?
            checkForGameEnd()
            
            
        } else {
            
            // is not a match
            
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            // flip them back over
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // reset the fisrFlippedCardIndex property
        
        firstFlippedCradIndex = nil
        
    }
    
    func checkForGameEnd() {
        
        // check if there's any card that is unmatch
        // assume that the user has won, loop through all the cards to see if all of them are match
        
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                // we have found a chard unmatch
                hasWon = false
                break
            }
        }
        
        if hasWon == true{
        
            // User has won, show an alert
            showAlert(title: "Congrats!!", message: "You won the game")
            
        }
        else {
            // user hasn't won, check if there is any time left
            
            if milliseconds <= 0 {
                showAlert(title: "Time's Up!", message: "Sorry, better luck next time!")
            }
        }
        
        
        
    }
    
    func showAlert(title: String, message: String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button to the user to dissmis it
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
    }
    

}

