//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func heightSliderChanged(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height)m"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight)Kg"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value

        calculatorBrain.calculateBMI(height: height, weight: weight)
        /** 1. How to Present the second view and pass value to it
         
             let secondVC = ResultViewController()  // present the second view controller
             self.present(secondVC, animatedLtrue, completion:nil)
             secondVC.BMIvalue = 0.0
        */
        /** 2. Use StoryBoard to creat link
                identifier: the same as the name showed on storyboard segue
                sender : the initiator of the segue
         
         */
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
    }
    
    /**
     1. set seague on storyboard
     2. Prepare value for segue before redirection to a second view
     3. dismiss the view controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Determine which view controller to switch
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
                // the destination view controller for the segue
                // ! : a forced downcast to a subclass from UIViewController
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
        }
    }
}























