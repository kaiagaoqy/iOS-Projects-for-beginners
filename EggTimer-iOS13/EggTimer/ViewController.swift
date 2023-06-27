//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBars: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var progressBar: NSLayoutConstraint!
    let eggTimes = ["Soft":5.0,"Medium":7.0,"Hard":12.0]
    var timer = Timer() // initiate a instance
    var secondsRemaining = 0.0
    var totalTime = 0.0
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        progressBars.progress = 1.0
        timer.invalidate() // stop the timer
    
        let hardness = sender.currentTitle! // return label of the sender, "!" mannual confirm it would not cause fail
        //print(eggTimes[hardness]) // Value of optional type must be unwrapped to a value -> Optional(5)
        
        totalTime = eggTimes[hardness]! // be sure to retrieve the value
        
        //print(res) // 5, 7, 12
        
        secondsRemaining = totalTime // set initial time
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer(){
        if secondsRemaining > 0{
            print("\(secondsRemaining) Seconds")
            secondsRemaining -= 1
            // Find the name of attributes listed at right
            progressBars.progress = Float(secondsRemaining/totalTime) // Cannot assign value of type 'Int' to type 'Float'
            // int / int = int -> 2/5 = 0 ; 2.0/5.0 = 0.4
        }
        else{
            timer.invalidate()
            progressBars.progress = 0.0
            titleLabel.text = "Done!"
        }
        
    }

    
}
