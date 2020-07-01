//
//  SoundManager.swift
//  Memorama
//
//  Created by Carlos Cardona on 18/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import Foundation
import AVFoundation


class SoundManager {
   
    var audioPlayer: AVAudioPlayer?
    
    enum  SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect){
        
        var soundFileName = ""
        
        switch effect {
            
            case .flip:
                soundFileName = "cardflip"
                
            case .match:
                soundFileName = "dingcorrect"
                
            case .nomatch:
                soundFileName = "dingwrong"
                
            case .shuffle:
                soundFileName = "shuffle"
        
        }
         // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // check that it's not nil
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play the sund effect
            audioPlayer?.play()
        }
        catch {
            print("couldn't create an audio player")
            return
        }

    }
}
