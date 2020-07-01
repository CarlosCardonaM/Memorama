//
//  cardrModel.swift
//  Memorama
//
//  Created by Carlos Cardona on 10/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // delcare an empty array to store numbers that we've generated
        
        var generatedNumbers  = [Int]()
        
        // Declare an empty array
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8 {
            
            
            // Generate a random numebr 1 to 13 (Names of the images in the assets)
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                // Create a two new card objects
                let card1 = Card()
                let card2 = Card()
                
                // Set their iamges
                card1.imageName = "card\(randomNumber)"
                card2.imageName = "card\(randomNumber)"
                
                
                // Add the to the array
                generatedCards += [card1, card2]
                
                // Add this number to the list of ganerated numbers
                generatedNumbers.append(randomNumber)
                
                print(randomNumber)
            }
            
            
            
        }
            
        // Randomize the cards with the array
        generatedCards.shuffle()
        
        
        // Return the array
        return generatedCards
        
    }
}
