//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Kaia Gao on 28/08/2019.

//  1. Use File -> new -> Cocoa Touch Class to create
//  2. Add link to StoryBoard:
//     1. show identity inspector -> custom class -> switch to current file, so that it will be opened in "Assistance View"
//      2. automatic -> current file

/**
 1. Introduction of class
 2. create UI programmatically without Storyboards
 
 */
import UIKit // import UIkit to use UIViewController

/**
  Class:
     class ClassName: SuperClass{
         // Property:

         // method:
         // rewrite functions have the same name of its parent’s method
         override func methodName( external_name parameter: Type) -> Int{
             super.property/ method() // call parent method/ property
     }

     }

 
 */
class ResultViewController: UIViewController {
    
    // initilize
    var bmiValue: String?
    var advice: String?
    var color: UIColor?

    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad() // load viewDidLoad method of parent class UIViewController

        bmiLabel.text = bmiValue // initiate by value passed in
        adviceLabel.text = advice
        view.backgroundColor = color // set background color
    }
    
    /**
        Go back to the previous view
     */
    @IBAction func recalculatePressed(_ sender: UIButton) {
        // dismissing the view controller it presented. 
        self.dismiss(animated: true, completion: nil) // nil: nothing happend after dismiss operation
    }
    

}
