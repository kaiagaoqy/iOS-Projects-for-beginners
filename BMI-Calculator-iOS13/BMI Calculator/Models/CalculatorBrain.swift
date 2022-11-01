//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Angela Yu on 28/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI? // set bmi as an Optional structure
    
    func getBMIValue() -> String {
        /**
         bmi?.value ?? 0.0 : if bmi is not nil then get its value, and set the defaul value as 0.0
         BMI value is not always safe: bmi!
         A better way is to use Optionals
            1. force unwrapping:  optional ! ( not safe to unwrap directly ! might have nil )
            2. chech for nil value: if(optional != nil)
            3. optional binding: if let safeOptional = myOptional  {...} (open the box to see whether it has value, then pass the value to a new variable 'safeOptional')
            4.Nil coalescing operator: optional ?? defaultValue ( if optional is nil then use the defaultValue
            5.Opyional Chaining : optional?.property (if the optional is not nil, then continue the chain
         */
        
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiTo1DecimalPlace
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "No advice"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / (height * height)

        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle!", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        }
    }
}
