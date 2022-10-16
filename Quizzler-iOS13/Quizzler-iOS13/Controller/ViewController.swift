//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Kaia Gao on 10/15/2022.
//  A Quizzler Project aim at introducing Code Structure
//

/**
 How to use MVC design pattern to split up Controller
 ViewController:
    1. tell the view what ot should display
    2. handle what to do with the user interation
    3. fetch the data and render the view
 
 
 */
import UIKit




class ViewController: UIViewController {
    
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var falseBtn: UIButton!
    @IBOutlet weak var trueBtn: UIButton!
    /** Use 2d array
    let quiz = [
        ["Four + Two is equal to Six","True"],
        ["Five - One is equal to Four","True"],
        [
            "Three + Three is equal to Four","False"
        ]
    ]
     */
    
    var quizBrain = QuizBrain() 
    

    @objc func setQuestion(){
        
        trueBtn.backgroundColor = UIColor.clear
        falseBtn.backgroundColor = UIColor.clear
        if(quizBrain.questionNumber < quizBrain.quiz.count){
            questionText.text = quizBrain.getQuestion()
            progressBar.progress = quizBrain.getProgress();
        }
        else{
            questionText.text = "Your Score is \(quizBrain.score)"
        }
        
    }
    
    /**
        run as soon as the app shows on the screen
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setQuestion()
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        
        
        if(quizBrain.questionNumber < quizBrain.quiz.count ){
            let userAnswer = sender.currentTitle!
            let isCorrect = quizBrain.checkAnswer(userAnswer) // use _ as external paramater
            if(isCorrect){
                quizBrain.score += 1
                sender.backgroundColor = UIColor.green
            }
            else{
                sender.backgroundColor = UIColor.red
            }
            //print("Q\(quizBrain.questionNumber+1): score = \(quizBrain.score)")
            
            quizBrain.nextQuestion()
            
        }
        else{
            quizBrain.questionNumber = 0
        }
        // call selector after 0.2s
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(setQuestion), userInfo: nil, repeats: false)
        
        
        
        
        
    }

}

